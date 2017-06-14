class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :matches, foreign_key: :created_by_user_id
  has_many :game_scores
  has_many :games, through: :game_scores

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  def build_simple_match(params = {})
    SimpleMatch.new(params.merge created_by_user: self)
  end

  # devise setup

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
