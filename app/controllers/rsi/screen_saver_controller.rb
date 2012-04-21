class Rsi::ScreenSaverController < ApplicationController
  before_filter :authenticate_user!
  layout :false
end
