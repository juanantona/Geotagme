class DropboxFile < ActiveRecord::Base

  has_attached_file :image, 

	:url => "/system/:class/:attachment/:id/:style/:basename.:extension",
	:path => "#{Rails.root}/public/system/:class/:attachment/:id/:style/:basename.:extension",
	:storage => ((Rails.env.production? || Rails.env.staging?) ? :s3 : :filesystem)
  
  validates_attachment_content_type :image, :content_type => ["image/jpeg", "image/jpg", "image/png"]

  def self.metadata(path, metadata)
 	 
 	  exif_data = EXIFR::JPEG.new(path)
 	
	  if metadata = "photo_geodata"
       return "POINT(#{exif_data.gps.latitude} #{exif_data.gps.longitude})"
    elsif metadata = "photo_timestamp"
       return exif_data.exif[:date_time_digitized]
    end 
  end
end
