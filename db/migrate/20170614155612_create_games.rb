class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.integer :home_user_id, index: true, null: false
      t.integer :home_user_score, null: false
      t.integer :away_user_id, index: true, null: false
      t.integer :away_user_score, null: false

      t.timestamps null: false
    end

    add_foreign_key :games, :users, column: :home_user_id
    add_foreign_key :games, :users, column: :away_user_id
  end
end
