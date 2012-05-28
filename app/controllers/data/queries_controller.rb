class Data::QueriesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_query, :except => [:index, :create]
  layout "dashboard"
  
  def index
    @queries = current_user.data_queries.order("id desc")
  end
  
  def create
    @query = current_user.data_queries.new(params[:query])
    unless @query.save
      @error = @query.errors.full_messages.join("; ")
    end
  end
  
  def update
    unless @query.update_attributes(params[:query])
      @error = @query.errors.full_messages.join("; ")
    end
    render :create
  end
  
  def show
    
  end
  
  def destroy
    @query.destroy
    redirect_to :action => :index
  end
  
  private 
  def find_query
    @query = current_user.data_queries.find_by_id(params[:id])
  end
end
