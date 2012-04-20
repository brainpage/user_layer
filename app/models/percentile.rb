class Percentile < ActiveRecord::Base
  def self.of(category, value)
    ap = self.where({:category => category}).where(["value <= ?", value.to_i]).order("value desc").first
    ap.try(:percentile) || 100
  end
end
