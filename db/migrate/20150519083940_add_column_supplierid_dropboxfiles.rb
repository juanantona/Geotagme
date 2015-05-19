class AddColumnSupplieridDropboxfiles < ActiveRecord::Migration
  def change
  	add_column :dropbox_files, :supplier_id, :integer
  end
end
