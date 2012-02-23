class Feed < ActiveRecord::Base
  belongs_to :user
  belongs_to :app
  
  scope :since, lambda{|time| where(time.blank? ? "1=1" : ["created_at > ?", Time.zone.parse(time)])}
  
  def as_json(options = {})
    super({:only => [:id], :methods => [:content, :createdAt, :ownerName]})
  end
  
  def content
    self.event
  end
  
  def ownerName
    self.app.care.try(:name)
  end
  
  def createdAt
    self.created_at.to_s(:db)
  end
end
