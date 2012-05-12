require 'spec_helper'

describe User do
  before do
    @user = Factory(:user, :email => "test@example.com", :password=>"111111", :password_confirmation=>"111111")   
  end
  
  it "should have many activity groups" do
    act = Factory(:activity, :creator => @user)
    Factory(:activity_user, :activity => act, :user => @user)
    @user.reload.should have(1).activities
    @user.should have(1).own_activities
  end
  
  it "should create activity_group" do
    @user.create_activity(2, 10)
    @user.should have(1).own_activities
    @user.should have(1).activities
  end
  
  it "should add sensor" do
    sensor = Factory(:sensor, :uuid => "1234")
    lambda{@user.add_sensor("1234")}.should change(@user.feeds, :count).by(1)
    sensor.reload.owner.should == @user
    @user.reload.feeds.first.originator.should == sensor
  end
  
  it "should delete oauth_accounts after destroy" do
    Factory(:oauth_account, :user => @user)
    lambda{@user.destroy}.should change(OauthAccount, :count).by(-1)   
  end
  
  describe "join_activity" do
    before do
      @act = @user.create_activity(5, 50)
      @new_user = Factory(:user, :email => "new_user@example.com")     
    end
    
    it "should join activity" do
      @new_user.join_activity(@act.token)
      @act.reload.users.should be_include(@new_user)
    end
    
    it "should generate feed for related users" do
      lambda{@new_user.join_activity(@act.token)}.should change(@user.feeds, :count).by(1)
      @user.reload.feeds.first.referer.should == @new_user
    end
    
    
  end
  
  describe "sensor_added" do
    it "should be true if has feed with xtype of add_sensor" do
      @user.should_not be_sensor_added
      
      @user.add_sensor(Factory(:sensor).uuid)
      @user.reload.should be_sensor_added
    end
  end
  
  describe "follow_invite" do
    before do
      @friend = Factory(:user, :email => "friend@example.com")
    end
    
    it "should become friend" do      
      @friend.follow_invite(@user.invite_token)
      @user.friends.should be_include(@friend)
      @friend.friends.should be_include(@user)
    end
    
    it "should generate friend_request feed if not allow stranger" do
      Factory(:user_setting, :user => @user, :allow_stranger => false)
      @friend.follow_invite(@user.invite_token)
      @user.friends.should_not be_include(@friend)
      @user.feeds.xtype("friend_request").size.should == 1
    end
  end
  
  describe "app_usage_stat" do
    it "should get percentage of app usages" do
      Factory(:app_usage, :user => @user, :app => "firefox", :dur => 200, :date => 1.day.ago)
      Factory(:app_usage, :user => @user, :app => "firefox", :dur => 100, :date => 10.day.ago)
      Factory(:app_usage, :user => @user, :app => "qq", :dur => 200, :date => 1.day.ago)
      Factory(:app_usage, :user => Factory(:user, :email=>"random@test.com"), :app => "firefox", :dur => 100, :date => 1.day.ago)

      @user.app_usage_stat.should == {"firefox" => 60, "qq" => 40}
      @user.app_usage_stat(7).should == {"firefox" => 50, "qq" => 50}
    end
  end

  describe "send_weibo" do
    it "should create a new weibo" do
      Factory(:oauth_account, :provider => "weibo", :token => "token", :user => @user)
      RestClient.stub!(:post).and_return(true)
      @user.send_weibo("Test")
    end
  end
end