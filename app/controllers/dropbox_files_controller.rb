class DropboxFilesController < ApplicationController
  
  def view_photos_on_dashboard

    @photos_in_db = DropboxFile.where(user_id: current_user.id)
    render "dashboard"
      
  end

  def render_new_photos
    
    render :json => { newPhotos: new_photos_to_render }
    
  end

  def new_photos_to_render

    photos_in_db = DropboxFile.where(user_id: current_user.id)
    previous_photos = photos_in_db.length

    sync_photos_with_dropbox()

    photos_in_db_after_sync = DropboxFile.where(user_id: current_user.id).order(created_at: :asc)
    new_photos_to_render = photos_in_db_after_sync.offset(previous_photos)

    return new_photos_to_render
      
  end

  private

  def sync_photos_with_dropbox()

    client = Dropbox::API::Client.new(:token => current_user.token, :secret => current_user.secret)
    dropbox_folder = "/photos"
    
    if client.ls(dropbox_folder).any?

      client.ls(dropbox_folder).each do |dropbox_element|
        unless dropbox_element.is_dir?
           download_photo(dropbox_element)
        end
      end
    end
  end

  def download_photo(photo)
     
    photo_in_db = DropboxFile.where(url: photo.direct_url.url).where(user_id: current_user.id)
    unless photo_in_db.exists?
      app_folder = "/app/assets/images/user_photos/"
      photo_name = photo.path.to_s.split("/").last
      photo_path = Rails.root.to_s + app_folder + photo_name
      
      begin
        open(photo_path, 'wb') do |file|
           file << photo.download
        end

        save_db_record(photo, photo_path)

      rescue
        puts "Exception occured while downloading..."
      end
    end
  end

  def save_db_record(photo, photo_path)

     local_file = File.open(photo_path)
     
     record = DropboxFile.new(:image => local_file)
     record.user_id = current_user.id
     record.url = photo.direct_url.url
     record.path = photo.path
     
     exif_data = EXIFR::JPEG.new(photo_path)
     begin
        record.geolocation = "POINT(#{exif_data.gps.latitude} #{exif_data.gps.longitude})"
        record.photo_timestamps = exif_data.exif[:date_time_digitized]
        record.save
     rescue
        puts "Photo hasn't geometadata"
     end 
      
     local_file.close
       
  end

end
