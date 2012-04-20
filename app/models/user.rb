class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_many :oauth_accounts
  has_many :apps
  has_many :feeds
  has_many :cares, :foreign_key=>:owner_id
  has_many :sensors, :foreign_key=>:owner_id
  
  has_many :activity_users
  has_many :activities, :through => :activity_users
  has_many :own_activities, :class_name => "Activity", :foreign_key => :creator_id
  has_one :setting, :class_name => "UserSetting"
  
  delegate :name, :image, :to => :active_oauth_account, :allow_nil => true
  
  def display_name
    self.name || self.email
  end
  
  after_create :generate_welcome_feed, :reset_authentication_token!
  
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
  
  def active_oauth_account
    self.oauth_accounts.order("updated_at desc").first
  end
  
  def create_activity(time_span, money_account)
    self.own_activities.create({:time_span => time_span, :money_account => money_account}).tap do |act|
      act.activity_users.create(:user => self)
    end
  end
  
  def friends
    users_in_relation RelationFriend
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
  
  def sensor_added?
    self.feeds.xtype(:add_sensor).present?
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
  
  def alert_client_install
    unless self.sensor_added?
      self.feeds.create(:xtype => :alert_client_install)
    end    
  end
  
  def accept_invite(token)
    user = User.find_by_invite_token(token)
    unless user.blank?
      rf = RelationFriend.create(:user => user, :client_user => self)
      user.feeds.create(:xtype => :accept_invite, :originator => rf, :referer => self)
    end
  end
  
  def generate_welcome_feed
    Feed.create(:xtype => :welcome, :user => self)
  end
  
  def fb_invite_link
    self.update_attribute(:invite_token, Digest::SHA1.hexdigest(Time.now.to_s)[0,20]) if self.invite_token.blank?
    
    options = {
      :app_id => Rails.configuration.fb_key,
      :name => "Protect your health",
      :description => "Compete with me to see who use facebook less. The loser will donate money to charity.",
      :link => "http://signup.brainpage.com/f/#{self.invite_token}",
      :redirect_uri => "http://localhost:3000/rsi/friends"
    }
  
    "http://www.facebook.com/dialog/send?#{options.to_param}"
  end
  
  def rsi_interval
    self.setting.try(:rsi_interval) || UserSetting.default_rsi_interval
  end
  
  private 
  def users_in_relation(relation)
    relation.where(:user_id => self.id).map(&:client_user) + relation.where(:client_user_id => self.id).map(&:user)
  end
end
