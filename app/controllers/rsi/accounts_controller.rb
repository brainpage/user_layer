class Rsi::AccountsController < ApplicationController
  def create
    user = User.new(:email => params[:email], :password => params[:password], :password_confirmation => params[:password])
    sign_in user if user.save
    
    redirect_to rsi_portals_path 
  end
end
