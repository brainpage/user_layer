class Sensor < ActiveRecord::Base
  belongs_to :owner, :class_name => "User"
  has_many :feeds, :as => :originator
  validates_presence_of :stype
  validates_presence_of :uuid
  
  #before_create :create_switch_sensor 
  
  def self.generate_uid
      Digest::MD5.hexdigest(((rand(10000) << (rand(100) + 100)) + Time.now.utc.to_i).to_s)
  end

end
