require 'spec_helper'

describe Rsi::FriendsController do
  render_views
  
  before do
    sign_in @user = Factory(:user, :invite_token => "123")
  end
  
  it "should respond to index" do
    get :index
    response.should be_success
  end
  
  it "should respond to invite" do
    get :invite
    response.should be_redirect
  end
  
  describe "weibo" do
    it "should create weibo" do
      post :weibo, :content => "content", :allow => "1"
      response.should be_redirect
    end
  end
  
  describe "follow" do
    it "should follow when signed in" do
      get :follow, :token => "123"
      response.should be_redirect
    end
    
    it "should set session and redirect if not signed in" do
      sign_out @user
      get :follow, :token => "123"
      session[:invite_token].should == "123"
      response.should be_redirect
    end
  end
end
