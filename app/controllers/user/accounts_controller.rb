class User::AccountsController < ApplicationController
  layout "data"
  
  def create
    @user = User.new(params[:user])
    if @user.save
      UserProfile.create({:user => @user}.merge(params[:profile]))
      sign_in @user
      redirect_to api_path
    else
      render :new
    end
  end
end
