class CreateLiveGames < ActiveRecord::Migration[5.1]
  def change
    create_table :live_games do |t|
      t.integer :home_user_id
      t.integer :away_user_id
      t.integer :home_user_score
      t.integer :away_user_score
      
      t.boolean :current, default: true
      t.timestamps
    end
  end
end
