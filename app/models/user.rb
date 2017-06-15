class User < ApplicationRecord
  devise :trackable, :omniauthable, :timeoutable, omniauth_providers: [:google_oauth2]

  OAUTH_ALLOWED_DOMAINS = %w(betterment.com).freeze

  DEFAULT_ELO = 1000
  MIN_GAMES_FOR_RATING = 3

  has_many :outgoing_challenges, foreign_key: :home_user_id, class_name: 'Challenge'
  has_many :incoming_challenges, foreign_key: :away_user_id, class_name: 'Challenge'
  has_many :elo_histories

  has_many :home_games, class_name: 'Game', foreign_key: :home_user_id
  has_many :away_games, class_name: 'Game', foreign_key: :away_user_id

  scope :by_elo, -> { order(elo: :desc) }
  scope :by_name, ->() { order(:full_name) }

  before_create :assign_default_elo

  def self.from_omniauth(auth)
    if oauth_allowed_domain? auth
      user = find_or_initialize_by(email: auth.info.email)

      if user
        user.full_name = auth.info.name
        user.save
      end

      user
    end
  end

  def self.rankable
    joins('INNER JOIN games AS gc ON gc.home_user_id = users.id OR gc.away_user_id = users.id')
      .group('users.id')
      .having('COUNT(gc.*) >= ?', MIN_GAMES_FOR_RATING)
  end

  def build_game(params = {})
    Game.new(params.merge(home_user: self))
  end

  def record_elo_history!
    elo_histories.create!(elo: elo)
  end

  def wins
    @wins ||= home_games.won_by_home_user.or(away_games.won_by_away_user).count
  end

  def losses
    @losses ||= home_games.won_by_away_user.or(away_games.won_by_home_user).count
  end

  def total_games
    wins + losses
  end

  def ranked?
    total_games >= MIN_GAMES_FOR_RATING
  end

  def display_rating
    ranked? ? elo : 'NEW'
  end

  def friendliness
    opponents = (all_games.played_since(1.month.ago)).map { |game| game.home_user == self ? game.away_user : game.home_user }.uniq.count

    if available_opponents.count > 0
      (opponents.to_f / available_opponents.count.to_f * 100.0).to_i
    else
      0
    end
  end

  def on_fire?
    all_games.count >= 3 && all_games.by_recency.limit(3).all? { |game| game.won_by?(self) }
  end

  def available_opponents
    self.class.where.not(id: id).by_name
  end

  class << self
    private

    def oauth_allowed_domain?(auth)
      OAUTH_ALLOWED_DOMAINS.any? { |domain| auth.extra.raw_info.hd == domain && auth.info.email =~ /@#{domain}\z/ }
    end
  end

  private

  def assign_default_elo
    self.elo = DEFAULT_ELO
  end

  def all_games
    @all_games ||= home_games.or(away_games)
  end
end
