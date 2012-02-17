class Care < ActiveRecord::Base
  belongs_to :owner, :class_name=>"User"
  has_many :apps
  validates_presence_of :name
  validates_presence_of :owner_id
end
