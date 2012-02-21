class MobileDevice < ActiveRecord::Base
  belongs_to :user
  
  def self.add(params)
    return if params[:uuid].blank?
    self.find_or_create_by_uuid(params[:uuid]).tap do |device|
      device.update_attributes(:name => params[:name], :platform => params[:platform], :version => params[:version])
      if device.user.blank?
        device.update_attribute(:user, User.create_mobile_user)
      end
    end
  end
end
