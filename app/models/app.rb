require 'rest_client'
class App < ActiveRecord::Base
  belongs_to :care
  belongs_to :app_list
  validates_presence_of :care_id
  validates_presence_of :app_list_id
  validates_presence_of :app_token
  before_validation :create_remote_app, :on=>:create
  after_destroy :delete_remote_app
  def app_create_resource
    @app_create_resource ||= RestClient::Resource.new "http://#{self.app_list.url}.dev"
  end
  def app_resource
    @app_resource ||= RestClient::Resource.new "http://#{self.app_list.url}.dev/#{self.app_token}"
  end
  def url
    "http://#{self.app_list.url}.dev/#{self.app_token}/"
  end
  def create_remote_app 
    logger.debug "TEST====="
    logger.debug app_create_resource
    logger.debug self.app_list.url
    app_create_resource.post :item_token => self.care.id do |response, req, result|
      case response.code
      when 200
        app_token=ActiveSupport::JSON.decode(response)["app_id"]
        self.app_token = app_token
        return true
      else
        return false
      end
    end
  end

  def delete_remote_app
    app_resource.delete
  end
end
