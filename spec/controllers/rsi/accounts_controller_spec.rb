require 'spec_helper'

describe Rsi::AccountsController do
  describe "create" do
    before do
      @user = Factory(:user, :email => "user@exmaple.com", :password => "123456")
    end
    
    it "should redirect to portals if success" do
      lambda{post :create, :email => "new@test.com", :password => "111111", :password_confirmation => "111111"}.should change(User, :count).by(1)
      response.should be_redirect
    end
    
    it "should redirect to signin if fail" do
      lambda{post :create, :email => "user@example.com", :format => :js}.should change(User, :count).by(0)
    end
   
  end
end
