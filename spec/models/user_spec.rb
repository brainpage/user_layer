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
  
  it "should join group" do
    act = Factory(:activity, :token => "abc")
    @user.join_activity("abc")
    act.reload.users.should be_include(@user)
  end
end