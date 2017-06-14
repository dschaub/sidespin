class DashboardsController < ApplicationController
  before_action :authenticate_user!

  def show
    @game = current_user.build_game
  end
end
