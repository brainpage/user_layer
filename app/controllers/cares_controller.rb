class CaresController < ApplicationController
  before_filter :authenticate_user!
  def index
  end

  def new
  end

  def create
    @care = Care.new(params[:care].merge(:owner => current_user))
    if @care.save
      redirect_to care_path(@care)
    else
      redirect_to cares_path
    end
  end

  def show
    @care = current_user.cares.find(params[:id])
    @app_lists = AppList.all
  end
end
