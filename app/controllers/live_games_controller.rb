class LiveGamesController < ApplicationController
  def new
    @live_game = LiveGame.new
    @available_users = User.all.map do |user|
      [user.full_name, user.id]
    end
  end

  def current
    @live_game = LiveGame.current
  end

  def show
    @live_game = LiveGame.find_by_id(params[:id])
  end

  def create
    @live_game = LiveGame.new
    if @live_game.update(create_params)
      redirect_to live_game_url(@live_game)
    else
      render :new # With errors or something
    end
  end

  def update
    @live_game = LiveGame.find_by_id(params[:id])
    if update_params.has_key?(:current)
      @live_game.update(update_params)
    else
      @live_game.update_score(update_params)
    end
    redirect_to live_game_url(@live_game)
  end

  private

  def update_params
    params.require(:live_game).permit(:user_side, :operator, :current)
  end

  def create_params
    params.require(:live_game).permit(:home_user_id, :away_user_id)
  end
end
