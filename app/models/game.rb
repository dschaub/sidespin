class Game < ApplicationRecord
  belongs_to :home_user, class_name: 'User'
  belongs_to :away_user, class_name: 'User'

  scope :played_by, ->(user) { where(home_user: user).or(where(away_user: user)) }
  scope :won_by_home_user, -> { where('home_user_score > away_user_score') }
  scope :won_by_away_user, -> { where('away_user_score > home_user_score') }
  scope :played_since, -> (since) { where('created_at >= ?', since) }
  scope :by_recency, -> { order(created_at: :desc) }

  validates :home_user, :home_user_score, :away_user, :away_user_score, presence: true

  validate :home_and_away_users_must_be_different

  after_create :update_user_elos, :complete_challenge

  def available_opponents
    home_user.available_opponents.map do |user|
      [user.full_name, user.id]
    end
  end

  def won_by?(user)
    (home_user == user && home_user_score > away_user_score) ||
      (away_user == user && away_user_score > home_user_score)
  end

  def opponent_of(user)
    home_user == user ? away_user : home_user
  end

  def display_result_for(user)
    "#{won_by?(user) ? 'W' : 'L'} #{home_user_score} - #{away_user_score}"
  end

  private

  def home_and_away_users_must_be_different
    errors.add(:base, 'Home and away users must be different') if home_user&.id == away_user&.id
  end

  def update_user_elos
    [home_user, away_user].each(&:record_elo_history!)

    home_player = Elo::Player.new(rating: home_user.elo)
    away_player = Elo::Player.new(rating: away_user.elo)

    game = home_player.versus(away_player)

    if home_user_score == away_user_score
      game.draw
    elsif home_user_score > away_user_score
      game.winner = home_player
    else
      game.winner = away_player
    end

    home_user.update!(elo: home_player.rating)
    away_user.update!(elo: away_player.rating)
  end

  def complete_challenge
    challenge = Challenge.pending.related_to_users(home_user, away_user)
    challenge&.complete!(self)
    true
  end
end
