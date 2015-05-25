class DropboxFilesController < ApplicationController
  
  def view_photos

    @photos = DropboxFile.where(supplier_id: current_user.id)
    
    render "dashboard"
      
  end

  def download_photos

    @photos_downloaded_previous = DropboxFile.where(supplier_id: current_user.id)

    offset = @photos_downloaded_previous.length

    download_photos_and_save_db_record()

    @photos_downloaded_now = DropboxFile.where(supplier_id: current_user.id).order(created_at: :asc).offset(offset)

    render :json => { moreThings: @photos_downloaded_now }
    
  end

  private

  def download_photos_and_save_db_record()

    @client = Dropbox::API::Client.new(:token => current_user.token, :secret => current_user.secret)

    @photo_folder = "/photos"

    if @client.ls(@photo_folder).any?

      @client.ls(@photo_folder).each do |dropbox_element|
                      
         unless dropbox_element.is_dir?
                   
           destination_file_full_path = Rails.root.to_s + "/" + dropbox_element.path.to_s.split("/").last
           
           unless DropboxFile.where(url: dropbox_element.direct_url.url).where(supplier_id: current_user.id).exists?
             
             # remote_photo = open(photo.direct_url.url,:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read
             
             begin
                 open(destination_file_full_path, 'wb') do |file|
                   file << dropbox_element.download
                 end
             rescue
                 puts "Exception occured while downloading..."
             end

             save_db_record(dropbox_element, destination_file_full_path)
                               
           end
        end
      end
    end
  end

  def save_db_record(dropbox_element, destination_file_full_path)

     local_file = File.open(destination_file_full_path)
     
     record = DropboxFile.new(:image => local_file)
     record.supplier_id = current_user.id
     record.url = dropbox_element.direct_url.url
     record.path = dropbox_element.path
     
     exif_data = EXIFR::JPEG.new(destination_file_full_path)
     

     begin
        record.geolocation = "POINT(#{exif_data.gps.latitude} #{exif_data.gps.longitude})"
        record.photo_timestamps = exif_data.exif[:date_time_digitized]
        record.save
     rescue

        puts "Photo hasn't geometadata"
     
     end 
      
     

     # File.delete(local_file)
  
  end

  def download_file_from_url(obj)
      destination_file_full_path = Rails.root.to_s + "/" + obj.path.to_s.split("/").last
      begin
        
        open(destination_file_full_path, 'wb') do |file|
          file << open(obj.direct_url.url,:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read
        end
        
      rescue
        puts "Exception occured while downloading..."
      end
      
  end

end
