class RemovecolumnRoleUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :role 
  end
end
