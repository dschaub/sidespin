class Game < ActiveRecord::Base
  belongs_to :match
  has_many :game_scores

  validates :sequence, numericality: { only_integer: true }

  def winner
    game_scores.sort(:rank).first.user
  end
end
