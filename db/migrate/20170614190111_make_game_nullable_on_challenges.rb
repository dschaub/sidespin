class MakeGameNullableOnChallenges < ActiveRecord::Migration[5.1]
  def change
    change_column_null :challenges, :game_id, true
  end
end
