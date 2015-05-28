class DropboxFilesController < ApplicationController
  
  def dashboard
    @photos_in_db = DropboxFile.where(user_id: get_photo_owner.id)
    render "dashboard"
  end

  def get_photo_owner
    photo_owner = DropboxFile.photo_owner(session[:role], session[:user_id])
  end

  def render_new_photos
    render :json => { newPhotos: get_new_photos_to_render }
  end

  def get_new_photos_to_render
    new_photos_to_render = []
    photos_in_dropbox = get_photos_in_dropbox()
    
    photos_in_dropbox.each do |photo|
      if check_photo_and_dowload(photo)
          new_photos_to_render << DropboxFile.where(share_url: photo.share_url.url).first   
      end  
    end
    new_photos_to_render
  end

  private

  def get_dropbox_folder
    return dropbox_folder = "/photos"
  end

  def get_photos_in_dropbox()
    client = Dropbox::API::Client.new(:token => get_photo_owner.token, :secret => get_photo_owner.secret)
    photos_in_dropbox = []
    
    if client.ls(get_dropbox_folder).any?
      client.ls(get_dropbox_folder).each do |dropbox_element|
        unless dropbox_element.is_dir?
           photos_in_dropbox << dropbox_element
        end
      end
    end
    photos_in_dropbox
  end

  def check_photo_and_dowload(photo)
    @photos_owner = DropboxFile.where(user_id: get_photo_owner.id)
    @photo_in_db = @photos_owner.find_in_db(photo.share_url.url)
    if @photo_in_db != nil
       @photo_in_db.set_direct_url(photo) 
    else  
       return download_photo(photo)
    end
    return false
  end

  def download_photo(photo)
    begin
      open(get_photo_path(photo), 'wb') do |file|
        file << photo.download
      end
    rescue
        puts "Exception occured while downloading..."
        return false
    end
    return save_db_record(photo, get_photo_path(photo))
  end
  
  def get_photo_path(photo)
    app_folder = "/app/assets/images/user_photos/"
    photo_name = photo.path.to_s.split("/").last
    return photo_path = Rails.root.to_s + app_folder + photo_name
  end

  def save_db_record(photo, path)
    local_file = File.open(path)
    record = DropboxFile.new(:image => local_file)
    if DropboxFile.save_photo_metadata(record, path)
      return record.save_photo_parameters(get_photo_owner.id, photo)
    else
      return false
    end
    local_file.close
  end
end