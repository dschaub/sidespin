class Game < ApplicationRecord
  belongs_to :home_user, class_name: 'User'
  belongs_to :away_user, class_name: 'User'

  validates :home_user, :home_user_score, :away_user, :away_user_score, presence: true

  validate :home_and_away_users_must_be_different

  after_create :update_user_elos, :complete_challenge

  def available_opponents
    home_user.available_opponents.map do |user|
      [user.full_name, user.id]
    end
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
    challenge = Challenge.pending.find_by(home_user: home_user, away_user: away_user) || Challenge.find_by(home_user: away_user, away_user: home_user)
    challenge&.complete!(self)
  end
end
