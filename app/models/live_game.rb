class LiveGame < ApplicationRecord
  belongs_to :home_user, class_name: 'User', foreign_key: :home_user_id
  belongs_to :away_user, class_name: 'User', foreign_key: :away_user_id

  after_save :check_if_finished

  def home_elo_rating
    home_user.elo
  end

  def away_elo_rating
    away_user.elo
  end

  def self.current
    find_by_current(true)
  end

  def update_user_score(user_side, operator=:+)
    current_score = send("#{user_side}_user_score")
    send("#{user_side}_user_score=", current_score.send(operator, 1))
    save
  end

  def update_score(params)
    update_user_score(params[:user_side], params[:operator])
  end

  alias_method :increment_user_score, :update_user_score

  def decrement_user_score(user_side)
    update_user_score(user_score, :-)
  end

  def server
    method_to_determine_server = total_score >= 40 ? :every_two : :every_five
    [:home, :away][send(method_to_determine_server)]
  end

  def underdog
    return nil unless home_user.present? && away_user.present?
    return nil if home_elo_rating == away_elo_rating
    home_elo_rating < away_elo_rating ? :home : :away
  end

  def finish_game!
    Game.create({
      home_user: home_user,
      away_user: away_user,
      home_user_score: home_user_score,
      away_user_score: away_user_score
    })
  end

  private

  def check_if_finished
    finish_game! if !current
  end

  def every_five
    total_score/5%2
  end

  def every_two
    total_score%2
  end

  def total_score
    home_user_score + away_user_score
  end
end
