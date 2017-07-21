class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @games = Game.played_by(@user).by_recency
  end
end
