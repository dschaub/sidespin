class Game < ApplicationRecord
  belongs_to :home_user, class_name: 'User'
  belongs_to :away_user, class_name: 'User'

  validates :home_user, :home_user_score, :away_user, :away_user_score, presence: true

  validate :home_and_away_users_must_be_different

  def available_opponents
    User.where.not(id: home_user.id).map do |user|
      [user.full_name, user.id]
    end
  end

  private

  def home_and_away_users_must_be_different
    errors.add(:base, 'Home and away users must be different') if home_user.id == away_user.id
  end
end
