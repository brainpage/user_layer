require 'spec_helper'

describe User do
  before do
    @user = Factory(:user)   
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
  
  it "should join group" do
    group = Factory(:activity_group, :code => "abc")
    @user.join_group("abc")
    group.reload.users.should be_include(@user)
  end
end