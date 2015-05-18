class DropboxFilesController < ApplicationController
  
  def welcome

      @client = dropbox_client
  
      @photos=[]  

      if @client.ls.any?
           @client.ls.each do |f|
             @photos << directory_hash(f)
          end
      end
      
      render 'welcome'
        
  end

  def viewmap

      @client = dropbox_client

      photo = @client.find('/photos/IMAG0394.jpg')
      destination_file_full_path = Rails.root.to_s + "/" + photo.path.to_s.split("/").last
            
      remote_photo = open(photo.direct_url.url,:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read
      # exif_data = EXIFR::JPEG.new(remote_photo)

      if File.exists?(destination_file_full_path)
      else
        open(destination_file_full_path, 'wb') do |file|
            file << photo.download
        end
      end

      if File.exists?(destination_file_full_path)
         dp_file = File.open(destination_file_full_path)
      end

      if dp_file
        DropboxFile.new(:image => dp_file).save!
      end
     
      exif_data = EXIFR::JPEG.new(destination_file_full_path)

      binding.pry

      @latitude = exif_data.gps.latitude
      @longitude = exif_data.gps.longitude

      render "viewmap"
    
  end

  private
 
  def directory_hash(obj)
      if obj.is_dir?
        list_hash(obj)
      else
        return obj
        # download_and_create(obj)
      end
  end
  
  def list_hash(obj)
      obj.ls.each do |s|
        directory_hash(s)
      end
  end
  
  def download_and_create(obj)
      path = download_file_from_url(obj)
      dp_file = File.open(path) if File.exists?(path)
      if dp_file
        DropboxFile.create(:image => dp_file)
        File.delete(dp_file)
      end
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
      destination_file_full_path
  end

end
