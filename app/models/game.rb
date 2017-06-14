class Game < ApplicationRecord
  belongs_to :home_user, class_name: 'User'
  belongs_to :away_user, class_name: 'User'

  validates :home_user, :home_user_score, :away_user, :away_user_score, presence: true

  validate :home_and_away_users_must_be_different

  after_create :update_user_elos

  def available_opponents
    User.where.not(id: home_user.id).map do |user|
      [user.full_name, user.id]
    end
  end

  private

  def home_and_away_users_must_be_different
    errors.add(:base, 'Home and away users must be different') if home_user.id == away_user.id
  end

  def update_user_elos
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
end
