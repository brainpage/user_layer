class ActivityGroupUser < ActiveRecord::Base
  belongs_to :activity_group
  belongs_to :user
end
