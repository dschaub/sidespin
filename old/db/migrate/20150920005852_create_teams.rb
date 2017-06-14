class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.timestamps
    end

    create_table :team_players do |t|
      t.integer :team_id, null: false
      t.integer :user_id, null: false
      t.timestamps

      t.foreign_key :users
      t.foreign_key :teams
    end

    add_index :team_players, :team_id
    add_index :team_players, :user_id
    add_index :team_players, [:team_id, :user_id], unique: true
  end
end
