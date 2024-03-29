class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :api_token, :api_secret_key
  
  has_many :oauth_accounts, :dependent => :destroy
  has_many :apps
  has_many :feeds, :dependent => :destroy
  has_many :cares, :foreign_key=>:owner_id
  has_many :sensors, :foreign_key=>:owner_id, :dependent => :destroy
  
  has_many :activity_users
  has_many :activities, :through => :activity_users
  has_many :own_activities, :class_name => "Activity", :foreign_key => :creator_id
  has_one :setting, :class_name => "UserSetting", :dependent => :destroy
  has_many :app_usages, :dependent => :destroy
  
  has_many :user_relations, :dependent => :destroy
  has_many :client_user_relations, :class_name => "UserRelation", :foreign_key => :client_user_id, :dependent => :destroy
  
  delegate :name, :image, :to => :active_oauth_account, :allow_nil => true
  delegate :allow_stranger, :to => :setting, :allow_nil => true
  
  after_create :generate_welcome_feed, :reset_authentication_token!
  
  has_one :profile, :class_name => "UserProfile"
  has_many :data_queries
  
  def active_oauth_account
    I18n.locale.to_s == "zh" ? self.weibo : self.facebook
  end
  
  def display_name
    self.name || self.email
  end
  
  def send_alert?
    self.setting.blank? or (self.setting.send_alert |= false)
  end
  
  def rsi_sensors
    self.sensors.computer
  end
  
  def sensor_added?
    self.rsi_sensors.present?
  end  
  
  def facebook
    self.oauth_accounts.with_provider("facebook").first
  end
  
  def weibo
    self.oauth_accounts.with_provider("weibo").first
  end
  
  def change_settings(options)
    (self.setting || UserSetting.create(:user => self)).tap do |setting|
      setting.update_attributes(options)
    end
  end
  
  def rsi_interval
    self.setting.try(:rsi_interval) || UserSetting.default_rsi_interval
  end
  
  def api_user?
    self.api_token.present? and self.api_secret_key.present?
  end
  
  def self.find_api_user(api_token, api_secret_key)
    self.where({:api_token => api_token, :api_secret_key => api_secret_key}).first
  end
  
  def self.create_mobile_user
    User.new.tap do |user|
      user.save(:validate => false)
      user.reset_authentication_token!
      user.cares.create(:owner => user, :name => "self")
    end
  end
  
  def after_token_authentication
    self.reset_authentication_token!
  end 
  
  def create_activity(time_span, money_account)
    self.own_activities.create({:time_span => time_span, :money_account => money_account}).tap do |act|
      act.activity_users.create(:user => self)
    end
  end
  
  def friends
    users_in_relation RelationFriend, {:confirmed => true}
  end
  
  def neighbours
    users_in_relation RelationNeighbour
  end
  
  def add_sensor(sensor_uuid)
    sensor = Sensor.find_by_uuid(sensor_uuid)
    if sensor.present? and sensor.owner_id != self.id
      sensor.update_attribute(:owner_id, self.id)
      self.feeds.create(:xtype => :add_sensor, :originator => sensor)
    end
  end
    
  def join_activity(token)
    act = Activity.find_by_token(token)
    if act.present? and !act.users.include?(self)
      act.activity_users.create(:user => self)
      
      act.users.each do |user|
        Feed.create(:xtype => :join_activity, :user => user, :referer => self, :originator => act)      
      end
    end
  end
  
  def follow_invite(token)
    user = User.find_by_invite_token(token)
    unless user.blank?
      confirmed = (user.allow_stranger != false)     
      rf = RelationFriend.create(:user => user, :client_user => self, :confirmed => confirmed)
      
      user.feeds.create(:xtype => confirmed ? :accept_invite : :friend_request, :originator => rf, :referer => self)
    end
  end
  
  def generate_welcome_feed
    Feed.create(:xtype => :welcome, :user => self)
  end
  
  def generate_invite_token
    self.update_attribute(:invite_token, Digest::SHA1.hexdigest(Time.now.to_s)[0,20]) if self.invite_token.blank?
  end
  
  def invite_link(zh = false)
    generate_invite_token
    (zh ? Rails.configuration.base_url_zh : Rails.configuration.base_url) + "f/#{self.invite_token}"
  end
  
  def fb_invite_link
    options = {
      :app_id => Rails.configuration.fb_key,
      :name => I18n.t(:fb_name),
      :description => I18n.t(:fb_desc),
      :link => self.invite_link,
      :redirect_uri => Rails.configuration.base_url + "rsi/friends",
      :picture => Rails.configuration.base_url + "assets/logo-big.png"
    }
  
    Rails.configuration.fb_send_url + "?" + options.to_param
  end
  
  def send_weibo(content)
    return if self.weibo.blank?
    options = {:access_token => self.weibo.token, :status => "#{content} #{self.invite_link(true)}"}   
    RestClient.post Rails.configuration.weibo_create_url, options
  end
  
  def app_usage_stat(past = nil)
    past = past.to_i
    sql = "select app, sum(dur) as total from #{AppUsage.table_name} where user_id = #{self.id}"
    sql << " and date >= '#{past.days.ago.beginning_of_day.to_s(:db)}'" if past > 0
    sql << " group by app order by total desc"
    data = AppUsage.find_by_sql(sql)
    total = data.map{|t| t.total.to_i}.sum
    
    {}.tap do |hash|
      data.each do |i|
        hash[i.app] = i.total.to_i * 100 / total
      end
    end
  end
  
  private 
  def users_in_relation(relation, conditions = {})
    relation.where({:user_id => self.id}.merge(conditions)).map(&:client_user) + relation.where({:client_user_id => self.id}.merge(conditions)).map(&:user)
  end
end
