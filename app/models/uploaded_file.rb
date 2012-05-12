class UploadedFile < ActiveRecord::Base
  has_attached_file :content, :styles => { :medium => "300x300>", :thumb => "100x100>" }
end
