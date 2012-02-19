class Feed < ActiveRecord::Base
  belongs_to :user
  
  def as_json(options = {})
    super({:only => [:id], :methods => [:content, :createdAt]})
  end
  
  def content
    self.event
  end
  
  def createdAt
    self.created_at.to_s(:db)
  end
end
