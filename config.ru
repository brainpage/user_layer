# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

if Rails.env.production?
  run UserLayer::Application
else
  run UserLayer::Application
end
