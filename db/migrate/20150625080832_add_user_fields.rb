class AddUserFields < ActiveRecord::Migration
  def change
  	change_column :users, :created_at, :datetime, :null => false
  	change_column :users, :updated_at, :datetime, :null => false
  	rename_column :users, :profile_pic, :avatar_file_name
    add_column :users, :avatar_content_type, :string
    add_column :users, :avatar_file_size, :string
    add_column :users, :avatar_updated_at, :datetime
    add_column :users, :password_digest, :string
  end
end
