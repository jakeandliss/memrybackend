class AddUserFields < ActiveRecord::Migration
  def change
  	remove_column :users, :profile_pic
  	change_column :users, :created_at, :datetime, :null => false
  	change_column :users, :updated_at, :datetime, :null => false
    add_column :users, :password_digest, :string
  end
end
