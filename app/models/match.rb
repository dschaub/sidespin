class Match < ActiveRecord::Base
  belongs_to :user, foreign_key: :created_by_user_id
  has_many :games
  has_many :game_scores, through: :games
  has_many :users, through: :game_scores

  has_one :ball_color
  has_one :ball_quality  
end
