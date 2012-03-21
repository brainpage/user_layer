require 'spec_helper'

describe Rsi::PortalsController do
  render_views
  
  before do
    sign_in @user = Factory(:user)
    
    @user.add_sensor(Factory(:sensor).uuid)
  end
  
  it "should respond to index" do
    get :index
    response.should be_success
  end
end
