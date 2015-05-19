class AddcolumnGeolocationDropboxfiles < ActiveRecord::Migration
  def change
  	add_column :dropbox_files, :geolocation, :point, geographic: true
  end
end
