class CreateDropboxFiles < ActiveRecord::Migration
  def change
    create_table :dropbox_files do |t|
      t.attachment :image	
      t.string :url
      t.timestamps null: false
    end
  end
end
