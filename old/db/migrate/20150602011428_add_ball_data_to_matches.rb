class AddBallDataToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :ball_color, :string
    add_column :matches, :ball_quality, :string
  end
end
