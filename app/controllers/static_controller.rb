class StaticController < ApplicationController
  layout "static"
  def home
    if zh? and Rails.env.production?
      redirect_to home_path
    end
  end
end
