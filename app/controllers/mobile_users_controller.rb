class MobileUsersController < ApplicationController
  def create
    user = MobileDevice.add(params[:mobile_user]).user
    render :json => {:user_id => user.id, :auth_token => user.authentication_token, :cares => user.cares}.to_json
  end
end
