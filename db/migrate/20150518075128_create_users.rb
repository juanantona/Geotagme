class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false 
      t.string :password_digest, null: false
      t.string :role, null: false
      t.string :token
      t.string :secret
      t.integer :supplier_id
      t.timestamps null: false
    end
  end
end
