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
    return photos_in_db_after_sync.offset(previous_photos)
      
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
    
    app_folder = "/app/assets/images/user_photos/"
    photo_in_db = DropboxFile.where(url: photo.direct_url.url).where(user_id: current_user.id)
    unless photo_in_db.exists?
      photo_name = photo.path.to_s.split("/").last
      photo_path = Rails.root.to_s + app_folder + photo_name
      
      begin
        open(photo_path, 'wb') do |file|
           file << photo.download
        end
      rescue
        puts "Exception occured while downloading..."
      end

      save_db_record(photo, photo_path)
    end
  end

  def save_db_record(photo, path)

    local_file = File.open(path)
     
    record = DropboxFile.new(:image => local_file)
    record.user_id = current_user.id
    record.url = photo.direct_url.url
    record.path = photo.path
    begin
      record.geolocation = DropboxFile.metadata(path, "photo_geodata")
      record.photo_timestamps = DropboxFile.metadata(path, "photo_timestamp")
      record.save
    rescue  
      puts "Exception occured while taking photo metadata..."
    end

    local_file.close
  end
end
