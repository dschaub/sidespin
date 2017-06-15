class Challenge < ApplicationRecord
  belongs_to :home_user, class_name: 'User'
  belongs_to :away_user, class_name: 'User'
  belongs_to :game, optional: true

  scope :pending, -> { where(played_at: nil, rejected_at: nil) }

  validate :must_not_be_played_and_rejected
  validate :must_only_have_one_pending_challenge

  after_create :send_reminder

  def self.related_to_users(user_1, user_2)
    find_by(home_user: user_1, away_user: user_2) || find_by(home_user: user_2, away_user: user_1)
  end

  def available_opponents
    home_user.available_opponents.map do |user|
      [user.full_name, user.id]
    end
  end

  def complete!(game)
    self.played_at = Time.zone.now
    self.game = game
    save!
  end

  def reject!
    self.rejected_at = Time.zone.now
    save!
  end

  def send_reminder
    away_user.remind(home_user)
  end

  private

  def pending?
    played_at.nil? && rejected_at.nil?
  end

  def must_not_be_played_and_rejected
    errors.add(:base, "Cannot play and reject the same challenge") if played_at.present? && rejected_at.present?
  end

  def must_only_have_one_pending_challenge
    existing_challenge = self.class.pending.related_to_users(home_user, away_user)
    if existing_challenge.present? && existing_challenge != self
      errors.add(:base, "Already have active challenge")
    end
  end
end
