class GamesController < ApplicationController
  def new
    @game = current_user.build_game
  end

  def create
    @game = current_user.build_game(create_params)

    if @game.save
      flash[:notice] = 'Game saved!'
      redirect_to dashboard_path
    else
      render :new
    end
  end

  private

  def create_params
    params.require(:game).permit(:home_user_score, :away_user_id, :away_user_score)
  end
end
