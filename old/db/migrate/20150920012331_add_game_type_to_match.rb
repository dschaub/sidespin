class AddGameTypeToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :activity, :string
    add_index :matches, :activity
  end
end
