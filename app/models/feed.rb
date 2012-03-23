class Feed < ActiveRecord::Base
  belongs_to :user
  belongs_to :referer, :class_name => "User"
  belongs_to :originator, :polymorphic => true 
  
  default_scope order("id desc")
  scope :since, lambda{|time| where(time.blank? ? "1=1" : ["created_at > ?", Time.zone.parse(time) + 1.second])}
  scope :xtype, lambda{|t| where(:xtype => t)}
  
  def as_json(options = {})
    super({:only => [:id], :methods => [:createdAt]})
  end
  
  #def content
  #  
  #end
  
  #def ownerName
  #  self.app.care.try(:name)
  #end
  #
  #def appName
  #  self.app.app_list.try(:name)
  #end
  
  def createdAt
    self.created_at.to_s(:db)
  end
end
