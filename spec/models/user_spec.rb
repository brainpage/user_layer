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
  
  describe "build_user" do
    it "should create new user if email not exist" do
      lambda{User.build_user({:email => "new@example.com", :password => "111111"})}.should change(User, :count).by(1)
    end
    
    it "should raise create error" do
      lambda{User.build_user({:password => "111111"})}.should_not be_blank
    end
    
    it "should return user if mail exist" do
      User.build_user({:email => "test@example.com", :password => "111111"}).should == @user
    end
    
    it "should raise error if mail and password doesn't match" do
      lambda{User.build_user({:email => "test@example.com", :password => "123456"})}.should raise_error("Wrong password!")
    end
  end
  
  it "should add sensor" do
    sensor = Factory(:sensor, :uuid => "1234")
    lambda{@user.add_sensor("1234")}.should change(@user.feeds, :count).by(1)
    sensor.reload.owner.should == @user
    @user.reload.feeds.first.originator.should == sensor
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
    
    it "should generate alert_sensor_install feed for user if no sensor added" do
      @new_user.join_activity(@act.token)
      @new_user.feeds.xtype(:alert_sensor_install).should_not be_blank
    end
  end
  
  describe "sensor_added" do
    it "should be true if has feed with xtype of add_sensor" do
      @user.should_not be_sensor_added
      
      @user.add_sensor(Factory(:sensor).uuid)
      @user.reload.should be_sensor_added
    end
  end
  
  describe "accept_invite" do
    it "should become friend" do
      @user.fb_invite_link
      friend = Factory(:user, :email => "friend@example.com")
      friend.accept_invite(@user.invite_token)
      @user.friends.should be_include(friend)
      friend.friends.should be_include(@user)
    end
  end

end