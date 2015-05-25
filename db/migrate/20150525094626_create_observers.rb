class CreateObservers < ActiveRecord::Migration
  def change
    create_table :observers do |t|
      t.integer :user_id, null: false
      t.string  :name, null: false
      t.string  :email, null: false 
      t.string  :password_digest, null: false
      t.date    :start_temp_permissions, null: false
      t.date    :terminate_temp_permissions, null: false
      t.timestamps
    end
  end
end
