class AddcolumnGeolocationDropboxfiles < ActiveRecord::Migration
  def change
  	add_column :dropbox_files, :geolocation, :st_point, geographic: true
  end
end
