class Sensor < ActiveRecord::Base
  belongs_to :owner, :class_name => "User"
  has_many :feeds, :as => :originator
  has_many :sensor_subscribers
  has_many :apps, :through => :sensor_subscribers
  has_many :features
  
  scope :computer, where(:stype => "computer")
  
  validates_presence_of :stype
  validates_presence_of :uuid
  
  def self.generate_uid
      Digest::MD5.hexdigest(((rand(10000) << (rand(100) + 100)) + Time.now.utc.to_i).to_s)
  end

  def connect_to_user(user_id)
    self.update_attribute(:owner_id, user_id)
    self.reload
    self.owner.feeds.create(:text => "Added to your things!", :originator => self)

    if self.stype == "computer"
        app = App.create(:user_id => user_id, app_list_id => AppList.find_by_url("rsi").id)
        SensorSubscriber.create(:sensor_id => self.id, :app_id => app.id)
    end
  end   


end
