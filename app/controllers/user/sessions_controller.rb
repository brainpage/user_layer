class User::SessionsController < ApplicationController
  def create
    @user = User.find_by_email(params[:email])
    if @user.blank?
      @error = I18n.t(:no_mail)
    elsif !@user.valid_password?(params[:password])
      @error = I18n.t(:wrong_password)
    else
      sign_in @user
    end
  end
end
