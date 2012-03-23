require 'spec_helper'

describe Rsi::ActivitiesController do
  render_views
  
  before do
    sign_in @user = Factory(:user)
    @act = Factory(:activity, :token => "111111")
  end
  
  it "should respond to index" do
    Factory(:activity, :token => "1234", :time_span => 5, :money_account => 50)
    @user.join_activity("1234")
    get :index
    response.should be_success
  end
  
  it "should redirect to facebook after create" do
    post :create, :time_span => 2, :money_account => 20
    response.should redirect_to(Activity.last.fb_invite_link)
  end
  
  it "should respond to invite" do
    get :invite, :token => "111111"
    response.should be_success
  end
  
  describe "join" do
    it "should redirect to activities index if current_user is not blank" do
      post :join, :id => "111111"
      response.should redirect_to(rsi_activities_path)
    end
    
    it "should redirect to facebook login if current_user is blank" do
      sign_out @user
      post :join, :id => "111111"
      response.should redirect_to("/auth/facebook")
    end
    
    it "should render 401 if wrong token" do
      post :join, :id=>"000"
      response.should_not be_success
    end
  end
end
