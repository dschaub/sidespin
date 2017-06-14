class CreateChallenges < ActiveRecord::Migration[5.1]
  def change
    create_table :challenges do |t|
      t.integer :home_user_id, index: true, null: false
      t.integer :away_user_id, index: true, null: false

      t.datetime :played_at
      t.datetime :rejected_at
      t.integer :game_id, index: :true, null: false
      t.timestamps null: false
    end

    add_foreign_key :challenges, :users, column: :home_user_id
    add_foreign_key :challenges, :users, column: :away_user_id
    add_foreign_key :challenges, :games
  end
end
