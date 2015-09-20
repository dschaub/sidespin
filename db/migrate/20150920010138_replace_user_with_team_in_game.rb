class ReplaceUserWithTeamInGame < ActiveRecord::Migration
  def up
    remove_index :game_scores, :user_id
    remove_foreign_key :game_scores, :users
    remove_column :game_scores, :user_id

    add_column :game_scores, :team_id, :integer, null: false
    add_foreign_key :game_scores, :teams
    add_index :game_scores, :team_id
  end

  def down
    add_column :game_scores, :user_id, :integer, null: false
    add_index :game_scores, :user_id
    add_foreign_key :game_scores, :users

    remove_foreign_key :game_scores, :teams
    remove_index :game_scores, :team_id
    remove_column :game_scores, :team_id
  end
end
