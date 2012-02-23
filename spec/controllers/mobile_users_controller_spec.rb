require 'spec_helper'

describe MobileUsersController do
  it "should respond to create" do
    post :create, :mobile_user => {:uuid => "234343"}
    response.should be_success
  end
end
