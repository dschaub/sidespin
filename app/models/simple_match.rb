class SimpleMatch
  include ActiveModel::Model

  attr_accessor :created_by_user, :player_one_name, :player_one_score, :player_two_name, :player_two_score

  validates :created_by_user, :player_one_name, :player_one_score, :player_two_name, :player_two_score, presence: true
  validates :player_one_score, :player_two_score, numericality: true

  def save
    valid? && save_match!
  end

  def activity
    :ping_pong
  end

  private

  def save_match!
    # find/create players
    # find/create teams
    # create match
    true
  end
end