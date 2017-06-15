class CurrentScoresController < ApplicationController
  def show
    @current = LiveGame.current
  end
end
