class AddcolumnPhotoTimestampsDropboxfiles < ActiveRecord::Migration
  def change
  	add_column :dropbox_files, :photo_timestamps, :datetime
  end
end
