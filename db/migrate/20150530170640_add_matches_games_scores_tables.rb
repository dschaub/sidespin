class AddMatchesGamesScoresTables < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :created_by_user_id, null: false
      t.datetime :held_at
      t.timestamps
    end

    add_index :matches, :created_by_user_id
    add_foreign_key :matches, :users, column: 'created_by_user_id'

    create_table :games do |t|
      t.integer :match_id, null: false
      t.integer :sequence, null: false
      t.timestamps

      t.foreign_key :matches
    end

    add_index :games, :match_id

    create_table :game_scores do |t|
      t.integer :game_id, null: false
      t.integer :user_id, null: false
      t.integer :score, null: false
      t.integer :rank, null: false

      t.foreign_key :games
      t.foreign_key :users
    end

    add_index :game_scores, [:game_id, :user_id], unique: true
    add_index :game_scores, :game_id
    add_index :game_scores, :user_id
  end
end
