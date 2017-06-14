class User < ApplicationRecord
  devise :trackable, :omniauthable, :timeoutable, omniauth_providers: [:google_oauth2]

  OAUTH_ALLOWED_DOMAINS = %w(betterment.com).freeze

  DEFAULT_ELO = 1000

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

  def build_game(params = {})
    Game.new(params.merge(home_user: self))
  end

  def record_elo_history!
    elo_histories.create!(elo: elo)
  end

  def wins
    home_games.where('home_user_score > away_user_score')
      .or(away_games.where('away_user_score > home_user_score')).count
  end

  def losses
    home_games.where('home_user_score < away_user_score')
      .or(away_games.where('away_user_score < home_user_score')).count
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
end
