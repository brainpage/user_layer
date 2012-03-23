require 'spec_helper'

describe Rsi::AccountsController do
  describe "create" do
    it "should create new user" do
      lambda{post :create, :email => "new@test.com", :password => "111111"}.should change(User, :count).by(1)
      response.should be_redirect
    end
  end
end
