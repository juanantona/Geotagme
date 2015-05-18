class DropboxFile < ActiveRecord::Base

  # attr_accessible(:url, :created_at, :updated_at, :image)
  # is deprecated
 
  has_attached_file :image, 

  :url => "/system/:class/:attachment/:id/:style/:basename.:extension",
  :path => "#{Rails.root}/public/system/:class/:attachment/:id/:style/:basename.:extension"
  # :storage => ((Rails.env.production? || Rails.env.staging?) ? :s3 : :filesystem))
  
  validates_attachment_content_type :image, :content_type => ["image/jpeg", "image/jpg", "image/png"]

end
