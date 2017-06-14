class Challenge < ApplicationRecord
  belongs_to :home_user, class_name: 'User'
  belongs_to :away_user, class_name: 'User'

  scope :pending, -> { where(completed_at: nil, rejected_at: nil) }
end
