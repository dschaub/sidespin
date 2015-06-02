class AddUsernameToUser < ActiveRecord::Migration
  def change
    add_column :users, :username, :string, null: false, unique: true
    add_column :users, :display_name, :string
    remove_column :users, :email
  end
end
