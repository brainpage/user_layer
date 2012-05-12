class UploadedFile < ActiveRecord::Base
  has_attached_file :content, 
    :storage => :s3, 
    :bucket => "brainpage.s3.first", 
    :s3_credentials => Rails.root.join("config/s3.yml"),
    :path => "files/:uuid/:filename"
    
  has_many :metadata, :as => :host
  belongs_to :sensor
  
  before_create :generate_uuid
  def generate_uuid
    self.uuid = Digest::SHA1.hexdigest((Time.now.to_i + rand(1000)).to_s)[0,8]
  end
  
  def image?
    self.content_content_type =~ /^image\//
  end
end
