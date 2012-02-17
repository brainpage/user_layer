class App < ActiveRecord::Base
  belongs_to :care
  belongs_to :apps_list

  validates_presence_of :care_id
  validates_presence_of :app_list_id
end
