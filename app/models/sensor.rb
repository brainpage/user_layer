class Sensor < ActiveRecord::Base
  belongs_to :owner, :class_name => "User"
  validates_presence_of :description
  validates_presence_of :stype
  validates_presence_of :uid
  before_create :create_switch_sensor 
  def self.generate_uid
      Digest::MD5.hexdigest(((rand(10000) << (rand(100) + 100)) + Time.now.utc.to_i).to_s)
  end

  def create_switch_sensor
    Switchboard.create_sensor(self.stype, self.uid) 
  end
end
