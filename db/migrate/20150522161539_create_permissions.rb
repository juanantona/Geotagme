class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :user_id, null: false
      t.integer :observer_id, null: false
      t.date :init_period_permission
      t.date :final_period_permision	
      t.timestamps null: false
    end
  end
end
