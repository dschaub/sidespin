class EloHistory < ApplicationRecord
  belongs_to :user

  validates :elo, presence: true
end
