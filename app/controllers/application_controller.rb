class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :print_ip
  
  private 
  def print_ip
    puts "<<<<<<<<<<<<<"
    puts request.remote_ip
  end
end
