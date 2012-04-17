class Rsi::SessionsController < ApplicationController
  def create
    @user = User.find_by_email(params[:email])
    if @user.blank?
      @error = "Email doesn't exist!"
    elsif !@user.valid_password?(params[:password])
      @error = "Wrong password!"
    else
      sign_in @user
    end
  end
end
