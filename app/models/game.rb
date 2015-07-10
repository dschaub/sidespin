class Game < ActiveRecord::Base
  belongs_to :match
  has_many :game_scores

  validates :sequence, numericality: { only_integer: true }

  def winner
    top = game_scores.order(:rank).first
    if game_scores.where(rank: top.rank).count > 1
      nil
    else
      top
    end
  end
end
