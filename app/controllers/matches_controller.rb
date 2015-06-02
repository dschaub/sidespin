class MatchesController < ApplicationController
  before_action :authenticate_user!

  def create
    player_one = User.find_by!(username: create_params[:player_one])
    player_two = User.find_by!(username: create_params[:player_two])

    player_one_rank = create_params[:player_one_score] > create_params[:player_two_score] ? 1 : 2
    player_two_rank = create_params[:player_two_score] > create_params[:player_one_score] ? 1 : 2

    match = current_user.matches.build(held_at: Time.now)
    game = match.games.build(sequence: 1)
    game_score1 = game.game_scores.build(user: player_one, score: create_params[:player_one_score], rank: player_one_rank)
    game_score2 = game.game_scores.build(user: player_two, score: create_params[:player_two_score], rank: player_two_rank)

    match.transaction do
      match.save!
      game.save!
      game_score1.save!
      game_score2.save!
    end

    redirect_to root_url
  end

  private

  def create_params
    params.permit(:player_one, :player_one_score, :player_two, :player_two_score)
  end
end
