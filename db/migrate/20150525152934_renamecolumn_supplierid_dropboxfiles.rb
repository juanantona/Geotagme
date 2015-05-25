class RenamecolumnSupplieridDropboxfiles < ActiveRecord::Migration
  def change
  	rename_column :dropbox_files, :supplier_id, :user_id
  end
end
