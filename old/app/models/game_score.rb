class GameScore < ActiveRecord::Base
  belongs_to :game
  belongs_to :team

  has_many :users, through: :team

  validates :score, numericality: true
  validates :rank, numericality: { only_integer: true }
end
