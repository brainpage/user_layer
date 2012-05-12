class Api::FilesController < ApplicationController
  layout 'api'
  
  protect_from_forgery :except => [:create]
  before_filter :authenticate_user!, :except => [:create]
  before_filter :find_sensor
  
  def index
    @files = @sensor.uploaded_files.paginate(:page => params[:page], :per_page => 30)
  end
  
  def create
    #curl -F "file=@/pics/pic.jpg" http://host/api/files
    
    if params[:file].kind_of?(Hash) and params[:file][:content].present?
      @file = @sensor.uploaded_files.create(params[:file])
      redirect_to :action => :index
    else
      @file = @sensor.uploaded_files.create(:content => params[:file])
      render :text => "success", :status => :ok and return
    end
  end
  
  protected
  def find_sensor
    if (@user = current_user).blank?
      @user = User.find_api_user(request.headers['api_token'], request.headers['api_secret_key'])
    end
    
    if @user.blank?
      render :text => "Authentication failed", :status => :unauthorized
    else
      @sensor = @user.sensors.find_by_uuid(params[:sensor_id])
      if @sensor.blank?
        render :text => "Sensor not found", :status => :not_found
      end
    end
  end
  
end
