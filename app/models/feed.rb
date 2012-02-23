class Feed < ActiveRecord::Base
  belongs_to :user
  belongs_to :app
  
  scope :since, lambda{|time| where(time.blank? ? "1=1" : ["created_at > ?", Time.zone.parse(time) + 1.second])}
  
  def as_json(options = {})
    super({:only => [:id], :methods => [:content, :createdAt, :ownerName, :appName]})
  end
  
  def content
    self.event
  end
  
  def ownerName
    self.app.care.try(:name)
  end
  
  def appName
    self.app.app_list.try(:name)
  end
  
  def createdAt
    self.created_at.to_s(:db)
  end
end
