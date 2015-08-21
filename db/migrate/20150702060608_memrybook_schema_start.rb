class MemrybookSchemaStart < ActiveRecord::Migration
  def change
    create_table   :users do |t|
      t.string     :first_name
      t.string     :last_name
      t.string     :email,                  index: true
      t.string     :avatar_file_name
      t.string     :avatar_content_type
      t.integer    :avatar_file_size
      t.datetime   :avatar_updated_at
      t.string     :encrypted_password,     default: '', null: false
      t.string     :reset_password_token,   index: true, unique: true
      t.datetime   :reset_password_sent_at
      t.datetime   :remember_created_at
      t.integer    :sign_in_count,          default: 0,  null: false
      t.datetime   :current_sign_in_at
      t.datetime   :last_sign_in_at
      t.inet       :current_sign_in_ip
      t.inet       :last_sign_in_ip
      t.timestamps null: false
    end

    create_table   :blogs do |t|
      t.string     :title
      t.text       :body
      t.string     :slug,       index: true, unique: true
      t.timestamps null: false
    end

    create_table   :entries do |t|
      t.string     :title
      t.string     :content
      t.date       :title_date
      t.references :user,       index: true
      t.timestamps null: false
    end
    add_foreign_key :entries, :users

    create_table   :tags do |t|
      t.string     :name,       index: true
      t.references :user
      t.string     :ancestry,   index: true
      t.timestamps null: false
    end
    add_foreign_key :tags, :users

    create_table   :resources do |t|
      t.references :entry,                   index: true
      t.string     :attachment_file_name
      t.string     :attachment_content_type, index: true
      t.integer    :attachment_file_size
      t.date       :attachment_updated_at
      t.timestamps null: false
    end
    add_foreign_key :resources, :entries

    create_table   :taggings do |t|
      t.references :tag,        index: true
      t.references :entry,      index: true
      t.timestamps null: false
    end
    add_foreign_key :taggings, :tags
    add_foreign_key :taggings, :entries
  end
end
