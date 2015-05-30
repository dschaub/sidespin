class GameScore < ActiveRecord::Base
  belongs_to :game
  belongs_to :user

  validates :score, numericality: true
  validates :rank, numericality: { only_integer: true }
end
