class AddcolumnShareurlDropboxfiles < ActiveRecord::Migration
  def change
  	add_column :dropbox_files, :share_url, :string
  end
end
