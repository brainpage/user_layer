require 'spec_helper'

describe User do
  before do
    @user = Factory(:user, :email => "test@example.com", :password=>"111111", :password_confirmation=>"111111")   
  end
  
  it "should have many activity groups" do
    ag = Factory(:activity_group, :creator => @user)
    Factory(:activity_group_user, :activity_group => ag, :user => @user)
    @user.reload.should have(1).activity_groups
    @user.should have(1).own_activity_groups
  end
  
  it "should create activity_group" do
    @user.create_activity_group
    @user.should have(1).own_activity_groups
    @user.should have(1).activity_groups
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
    @user.add_sensor("1234")
    sensor.reload.owner.should == @user
  end
  
  it "should join group" do
    group = Factory(:activity_group, :code => "abc")
    @user.join_group("abc")
    group.reload.users.should be_include(@user)
  end
end