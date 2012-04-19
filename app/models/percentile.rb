class Percentile < ActiveRecord::Base
  def self.of(app, value)
    ap = self.where(app.blank? ? "app is null" : {:app => app}).where(["value <= ?", value]).order("value desc").first
    ap.try(:percentile) || 100
  end
end
