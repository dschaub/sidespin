class Match < ActiveRecord::Base
  ACTIVITIES = {
      ping_pong: 'Ping Pong',
      beer_pong: 'Beer Pong',
      corn_hole: 'Corn Hole'
  }

  belongs_to :user, foreign_key: :created_by_user_id
  has_many :games
  has_many :game_scores, through: :games
  has_many :users, through: :game_scores

  validates :activity, in: ACTIVITIES.keys
end
