class Sensor < ActiveRecord::Base
  belongs_to :owner, :class_name => "User"
  has_many :feeds, :as => :originator
  validates_presence_of :stype
  validates_presence_of :uid
  #before_create :create_switch_sensor 
  def self.generate_uid
      Digest::MD5.hexdigest(((rand(10000) << (rand(100) + 100)) + Time.now.utc.to_i).to_s)
  end

  def connect_to_user(user_id)
    self.update_attribute(:owner_id, user_id)
    self.reload
    self.owner.feeds.create(:text => "Added to your things!", :originator => self)
  end   


end
