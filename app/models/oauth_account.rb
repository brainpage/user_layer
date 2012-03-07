class OauthAccount < ActiveRecord::Base
  belongs_to :user
  
  scope :with_provider, lambda{|provider| where(:provider => provider)}
  scope :with_uuid, lambda{|uuid| where(:uuid => uuid)}
  
  def self.build_for_user(user, auth_hash)
    if user.blank?
      user = User.new.tap{|u| u.save(:validate => false)} 
    end
    
    data = {
      :user => user,
      :provider => auth_hash.provider,
      :uuid => auth_hash.uid.to_s,
      :token => auth_hash.credentials.token,
      :token_expires_at => auth_hash.credentials.expires_at,
      :email => auth_hash.info.email,
      :name => auth_hash.info.name,
      :image => auth_hash.info.image
    }
    
    obj = self.with_provider(auth_hash.provider).with_uuid(auth_hash.uid.to_s).first
    obj.blank? ? self.create(data) : obj.update_attributes(data)
    
    user
  end
end
