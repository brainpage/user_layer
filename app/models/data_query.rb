class DataQuery < ActiveRecord::Base
  belongs_to :user
  
  validates :name, :presence => true, :uniqueness => {:scope => :user_id}
  validates :query_clause, :presence => true
end
