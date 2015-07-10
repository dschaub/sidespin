class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :matches, foreign_key: :created_by_user_id
  has_many :game_scores
  has_many :games, through: :game_scores

  validates :username, presence: true

  def record
    games.each_with_object({ wins: 0, losses: 0, ties: 0 }) do |game, obj|
      if game.winner == self
        obj[:wins] += 1
      elsif game.winner.nil?
        obj[:ties] += 1
      else
        obj[:losses] += 1
      end
    end
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
