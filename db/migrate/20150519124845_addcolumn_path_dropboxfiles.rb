class AddcolumnPathDropboxfiles < ActiveRecord::Migration
  def change
  	add_column :dropbox_files, :path, :string
  end
end
