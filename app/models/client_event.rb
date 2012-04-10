class ClientEvent < ActiveRecord::Base
  scope :day, lambda{|day| time = day.to_i.days.ago; where(["created_at >= ? and created_at < ?", time.beginning_of_day, time.end_of_day])}
  has_many :client_apps

  def self.build(msg)
    if msg["code"] == "update" and msg["data"].present?
      self.create(msg["data"].extract!("dur", "app", "dst", "keys", "msclks", "scrll", "mnum"))
    end
  end
  
  def as_json(options = {})
    super({:only => [:point], :methods => [:t, :apps]})
  end
  
  def t
    self.created_at.to_i
  end
  
  def apps
    self.client_apps.map do |t|
      {:v => t.app, :d => t.dur, :keys => t.keys, :msclks => t.msclks, :dst => t.dst, :point => rand(50)}
    end
  end
  
  #def point
  #  (self.mnum.to_i + self.keys.to_i / 4 + Math.log2(self.dst.to_i + self.scrll.to_i + 1)).round(2)
  #end
  
  def timestamp
    self.created_at.to_s(:db)
  end
end
