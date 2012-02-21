require 'spec_helper'

describe MobileDevice do
  before do
    @device = Factory(:mobile_device)
  end
  
  describe 'add' do
    it "should add device and init associated user" do
      device = MobileDevice.add({:uuid => "3793993", :name => "iPhone", :platform => "iOS", :version => "5.0"})
      device.id.should be_present
      device.user.authentication_token.should_not be_blank
      device.user.should have(1).cares
    end
    
    it "should add device with same uuid once" do
      lambda{MobileDevice.add({:uuid => "123456"})}.should change(MobileDevice, :count).by(1)
      lambda{MobileDevice.add({:uuid => "123456"})}.should_not change(MobileDevice, :count)
    end
  end
end
