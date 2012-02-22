require 'spec_helper'

describe Feed do
  before do
    @user = Factory(:user)
    @feed = Factory(:feed)
  end
  
  describe 'to_json' do
    it "should have care attr" do
      App.any_instance.stub(:create_remote_app).and_return(true)    
      app = Factory(:app, :care => Factory(:care, :owner => @user, :name => "Care 1"), :app_list => Factory(:app_list))
      Factory(:feed, :user => @user, :app => app).to_json.should_not be_blank
    end
  end
end
