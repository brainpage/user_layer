class Activity < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  
  has_many :activity_users
  has_many :users, :through => :activity_users
  
  before_create :init_token
  def init_token
    self.token = Digest::SHA1.hexdigest(Time.now.to_s)[0,20] if self.token.blank?
  end
  
  def fb_invite_link
    options = {
      :app_id => Rails.configuration.fb_key,
      :name => "User facebook less for charity",
      :description => "Compete with me to see who use facebook less. The loser will donate money to charity.",
      :link => "http://signup.brainpage.com/act/#{self.token}",
      :redirect_uri => "http://localhost:3000/rsi/activities"
    }
  
    "http://www.facebook.com/dialog/send?#{options.to_param}"
  end
end
