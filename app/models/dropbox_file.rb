class DropboxFile < ActiveRecord::Base

  has_attached_file :image, 

	:url => "/system/:class/:attachment/:id/:style/:basename.:extension",
	:path => "#{Rails.root}/public/system/:class/:attachment/:id/:style/:basename.:extension",
	:storage => ((Rails.env.production? || Rails.env.staging?) ? :s3 : :filesystem)
  
  validates_attachment_content_type :image, :content_type => ["image/jpeg", "image/jpg", "image/png"]

  def self.photo_owner(role, id)
    if role == 'photographer'
      User.find_by_id(id)
    elsif role == 'observer'
      observer_host = Observer.find_by_id(id).user_id
      User.find_by_id(observer_host)
    end      
  end

  def self.metadata(path, metadata)
 	 
 	  exif_data = EXIFR::JPEG.new(path)
 	
	  if metadata == "photo_geodata"
       return "POINT(#{exif_data.gps.latitude} #{exif_data.gps.longitude})"
    elsif metadata == "photo_timestamp"
       return exif_data.exif[:date_time_digitized]
    end 
  end

  def self.find_in_db(share_url)
    if exists?(:share_url => share_url)
        photo = find_by share_url: share_url
    end
    photo

  end

  def set_direct_url(photo)
    self.url = photo.direct_url.url
    self.save
  end
end
