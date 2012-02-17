class AppsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_care

  def new
    @app_lists = AppList.all
  end

  def create
    app = App.new(:care_id=>params[:care_id], :app_list_id=>params[:app_list_id])
    unless app.save  
    flash[:error] = "Error creating application"
    end
    redirect_to care_path(params[:care_id]) 
  end
  def edit
    @app = @care.apps.find(params[:id])
  end

  def destroy 
    @app = @care.apps.find(params[:id])
    @app.destroy
    redirect_to care_path(@care) 
  end

  private
  def get_care
    @care = current_user.cares.find(params[:care_id])
  end
end
