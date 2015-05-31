class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :matches, foreign_key: :created_by_user_id
  has_many :game_scores
  has_many :games, through: :game_scores
end
