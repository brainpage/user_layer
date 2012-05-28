class User::SettingsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_profile
  layout "dashboard"
  
  def index
    
  end
  
  def create
    flash[:info] = @profile.update_attributes(params[:profile]) ? "Save successfully!" : @profile.errors.full_messages.join("; ")
    redirect_to :action => :index
  end
  
  private
  def find_profile
    @profile = current_user.profile || UserProfile.create(:user => current_user)
  end
end
