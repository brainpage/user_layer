class CaresController < ApplicationController
  before_filter :authenticate_user!
  def index
  end

  def new
  end

  def create
    respond_to do |format|
      format.html{
        @care = Care.new(params[:care].merge(:owner => current_user))
        if @care.save
          redirect_to care_path(@care)
        else
          redirect_to cares_path
        end
      }
      format.json { 
        @care = Care.create({:name => params[:name], :phone_number => params[:phoneNumber], :email => params[:email]}.merge(:owner => current_user))
        render :json => @care.to_json
      }
    end
    
  end

  def show
    @care = current_user.cares.find(params[:id])
    @app_lists = AppList.all
  end
end
