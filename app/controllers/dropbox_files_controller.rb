class DropboxFilesController < ApplicationController
  
  def view_photos_on_dashboard

    @photos = DropboxFile.where(user_id: current_user.id)
    render "dashboard"
      
  end

  def download_photos

    photos_in_db = DropboxFile.where(user_id: current_user.id)
    offset = photos_in_db.length

    download_photos_and_save_db_record()
    
    dropbox_photos_to_download = photos_in_db.order(created_at: :asc).offset(offset)
    render :json => { newPhotos: dropbox_photos_to_download }
    
  end

  private

  def download_photos_and_save_db_record()

    client = Dropbox::API::Client.new(:token => current_user.token, :secret => current_user.secret)
    photo_folder = "/photos"

    if client.ls(photo_folder).any?

      client.ls(photo_folder).each do |dropbox_element|
                      
         unless dropbox_element.is_dir?
                   
           photo_in_db = DropboxFile.where(url: dropbox_element.direct_url.url).where(user_id: current_user.id)

           unless photo_in_db.exists?
           
             photo_destination_path = Rails.root.to_s + "/app/assets/images/user_photos/" + dropbox_element.path.to_s.split("/").last
             begin
                 open(photo_destination_path, 'wb') do |file|
                   file << dropbox_element.download
                 end
             rescue
                 puts "Exception occured while downloading..."
             end

             save_db_record(dropbox_element, photo_destination_path)
                               
           end
        end
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
