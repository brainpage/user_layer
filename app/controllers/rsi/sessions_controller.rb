class Rsi::SessionsController < ApplicationController
  def create
    user = OauthAccount.build_for_user(current_user, request.env['omniauth.auth'])
    sign_in user
    redirect_to rsi_portals_path
  end
end
