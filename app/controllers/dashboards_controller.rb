class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @game = current_user.build_game
    @leaderboard_users = User.by_elo.limit(10)
  end
end
