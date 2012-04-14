require 'spec_helper'

describe AppPercentile do

  it "should return percentile by app" do
    Factory(:app_percentile, :value => 1000, :percentile => 20)
    Factory(:app_percentile, :app => "firefox", :value => 300, :percentile => 10)
    Factory(:app_percentile, :app => "firefox", :value => 250, :percentile => 20)
    Factory(:app_percentile, :app => "firefox", :value => 200, :percentile => 40)
    
    AppPercentile.of("firefox", 240).should == 40
    AppPercentile.of("firefox", 250).should == 20
    AppPercentile.of(nil, 240).should == 100
  end
end
