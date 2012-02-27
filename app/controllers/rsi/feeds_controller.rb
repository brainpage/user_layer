class Rsi::FeedsController < ApplicationController
  before_filter :auth_request
  
  SECRET_KEY = "ea1020da-cea9-4cef-848e-6a5121af11d4"
  
  def index
    render :text => "hello"
  end
  
  protected
  def auth_request
    sensor_token, auth_token = params[:sensor_token], params[:auth_token]
    key = sensor_token + SECRET_KEY
    unless Digest::SHA1.hexdigest(key) == auth_token
      render :file => "public/401.html", :status => :unauthorized, :layout => false
    end
  end
end
