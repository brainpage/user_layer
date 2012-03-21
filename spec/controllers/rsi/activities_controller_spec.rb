require 'spec_helper'

describe Rsi::ActivitiesController do
  before do
    sign_in Factory(:user)
  end
  
  it "should redirect to facebook after create" do
    post :create, :time_span => 2, :money_account => 20
    response.should redirect_to(Activity.last.fb_invite_link)
  end
end
