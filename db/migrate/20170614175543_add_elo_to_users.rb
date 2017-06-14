class AddEloToUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :elo, :integer

    execute 'update users set elo = 1000'

    change_column_null :users, :elo, false
  end

  def down
    remove_column :users, :elo
  end
end
