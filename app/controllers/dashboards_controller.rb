class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @game = current_user.build_game
    @leaderboard_users = User.by_elo
    @leaderboard_users = @leaderboard_users.limit(10) unless params[:all_players].present?
  end
end
