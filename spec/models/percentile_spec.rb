require 'spec_helper'

describe Percentile do

  it "should return percentile by app" do
    Factory(:percentile, :value => 1000, :percentile => 20)
    Factory(:percentile, :category => "firefox", :value => 300, :percentile => 10)
    Factory(:percentile, :category => "firefox", :value => 250, :percentile => 20)
    Factory(:percentile, :category => "firefox", :value => 200, :percentile => 40)
    
    Percentile.of("firefox", 240).should == 40
    Percentile.of("firefox", 250).should == 20
    Percentile.of(nil, 240).should == 100
  end
end
