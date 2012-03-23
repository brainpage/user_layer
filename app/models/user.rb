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
  
  delegate :name, :image, :to => :active_oauth_account, :allow_nil => true
  
  after_create :generate_welcome_feed
  
  def self.create_mobile_user
    User.new.tap do |user|
      user.save(:validate => false)
      user.reset_authentication_token!
      user.cares.create(:owner => user, :name => "self")
    end
  end
  
  def self.build_user(params)
    user = self.find_by_email(params[:email])
    
    if user.blank?
      user = self.create!(:email => params[:email], :password => params[:password], :password_confirmation => params[:password])
    else
      raise "Wrong password!" unless user.valid_password?(params[:password])
    end
    user
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
      
      unless self.sensor_added?
        self.feeds.create(:xtype => :alert_sensor_install, :originator => act)
      end
    end
  end
  
  def generate_welcome_feed
    Feed.create(:xtype => :welcome, :user => self)
  end
  
  def sensor_added?
    self.feeds.xtype(:add_sensor).present?
  end
end
