class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @showing_all = params[:all_players].present?
    @game = current_user.build_game
    @leaderboard_users = User.by_elo
    @leaderboard_users = @leaderboard_users.rankable.limit(20) unless @showing_all
  end
end
