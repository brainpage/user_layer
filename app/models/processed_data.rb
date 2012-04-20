class ProcessedData < ActiveRecord::Base
  def as_json(options = {})
    super(:only => [:category, :value])
  end
end
