class LiveGamesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :update_or_create

  def new
    @live_game = LiveGame.new
    @available_users = User.all.map do |user|
      [user.full_name, user.id]
    end
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
    if @live_game.update(update_params)
      head :ok
    else
      # Error or something
    end
  end

  def update_or_create
    @live_game = LiveGame.current
    player = User.find_by_tag_id(params[:tag_id])

    if player.nil?
      render :text => "User not found.", :status => 404
    end

    if @live_game.present?
      @live_game.away_user = player
    else
      @live_game = LiveGame.new
      @live_game.update_attribute(:home_user_id, player.id)
    end

    head :ok
  end

  private

  def update_params
    params.require(:live_game).permit(:user_type, :score_updater)
  end

  def create_params
    params.require(:live_game).permit(:home_user_id, :away_user_id)
  end
end
