class Game < ActiveRecord::Base
  belongs_to :match
  has_many :game_scores

  validates :sequence, numericality: { only_integer: true }
end
