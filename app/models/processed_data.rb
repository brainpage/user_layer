class ProcessedData < ActiveRecord::Base
  scope :all_time, where(:is_all_time => true)
  
  def as_json(options = {})
    super(:only => [:category, :value])
  end
end

class Mean < ProcessedData
end

