class ApplicationController < ActionController::Base
  protect_from_forgery
  include UserHook
  
  #before_filter :log_activity 

  def log_activity
    #We log the user's IP and computer info.  For matching purposes.
   
    if current_user
      logger.info "not here"
    end
  end

end
