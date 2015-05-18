class DropboxFilesController < ApplicationController
  
  def welcome
  
      @client = Dropbox::API::Client.new(:token => session[:access_token], :secret => session[:access_secret_token])
      
      @photos=[]  

      if @client.ls.any?
           @client.ls.each do |f|
             @photos << directory_hash(f)
          end
      end
      
      render 'welcome'
        
  end

  def viewmap

      photo = @client.find('/photos/IMAG0394.jpg')
      destination_file_full_path = Rails.root.to_s + "/" + photo.path.to_s.split("/").last
      # binding.pry
      # @image_input = MiniMagick::Image.open(photo.download)
      # @image_input.write(destination_file_full_path)
      
      remote_photo = open(photo.direct_url.url,:ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read
      # binding.pry
      # exif_data = EXIFR::JPEG.new(remote_photo)
      
      open(destination_file_full_path, 'wb') do |file|
          file << photo.download
      end

      exif_data = EXIFR::JPEG.new(destination_file_full_path)
      @latitude = exif_data.gps_latitude[0].to_f+exif_data.gps_latitude[1].to_f/60+exif_data.gps_latitude[2].to_f/3600
      @longitude = -(exif_data.gps_longitude[0].to_f+exif_data.gps_longitude[1].to_f/60+exif_data.gps_longitude[2].to_f/3600)

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
