require 'spec_helper'

describe Rsi::PortalsController do
  render_views
  
  before do
    sign_in @user = Factory(:user)
    
    @user.add_sensor(Factory(:sensor).uuid)
    act = @user.create_activity(3,20)
    Factory(:user, :email => "new@example.com").join_activity(act.token)
    
    link = @user.fb_invite_link
    Factory(:user, :email => "friend@example.com").accept_invite(@user.invite_token)
  end
  
  it "should respond to index" do
    get :index
    response.should be_success
  end 
end
