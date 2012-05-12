require 'spec_helper'

describe OauthAccount do
  
  describe "build for user" do
    before do
      @auth_hash = Hashie::Mash.new(
        :provider => "google", 
        :uid => 113785386423313999712, 
        :credentials => Hashie::Mash.new(
          :expires_at => 1331140350,
          :token => "ya29.AHES6ZSlZ2JA2fXuT"
        ),
        :info => Hashie::Mash.new(
          :email => "test@example.com",
          :name => "Mr.Test",
          :image => "https://lh5.googleusercontent.com/"
        )
      )
    end
    
    it "should generate user if user blank" do
      OauthAccount.build_for_user(nil, @auth_hash).id.should_not be_blank
    end
    
    it "should create oauth_account" do
      lambda{OauthAccount.build_for_user(nil, @auth_hash)}.should change(OauthAccount, :count).by(1)
    end
    
    it "should link user if with same email" do
      user = Factory(:user, :email => "test@example.com")
      OauthAccount.build_for_user(nil, @auth_hash).should == user
    end
    
    it "should update oauth_account if exist" do
      oa = Factory(:oauth_account, :provider => "google", :uuid => "113785386423313999712")
      lambda{OauthAccount.build_for_user(nil, @auth_hash)}.should_not change(OauthAccount, :count)
      oa.reload.name.should == "Mr.Test"
    end
  end
end
