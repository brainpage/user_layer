# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

if Rails.env.production?
  map '/rsi' do
    run UserLayer::Application
  end
else
  run UserLayer::Application
end
