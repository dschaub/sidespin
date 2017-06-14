class CreateEloHistory < ActiveRecord::Migration[5.1]
  def change
    create_table :elo_histories do |t|
      t.belongs_to :user, foreign_key: true, index: true, null: false
      t.integer :elo, null: false

      t.timestamps null: false
    end
  end
end
