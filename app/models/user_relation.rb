class UserRelation < ActiveRecord::Base
  belongs_to :user
  belongs_to :client_user, :class_name => "User"
end
