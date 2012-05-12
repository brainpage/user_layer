require 'spec_helper'

describe Metadatum do
  before do
    @file = Factory(:uploaded_file)
    @data = Factory(:metadatum, :host => @file)
  end
  
  it "should have metadata" do
    @file.metadata.should == [@data]
  end
end
