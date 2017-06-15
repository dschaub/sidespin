class Api::ScoreButtonPressesController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    button = params.permit(:button)[:button]
    game = LiveGame.current

    if game.present?
      if button == 'cheezit'
        game.update_user_score(:home)
      elsif button == 'doritos'
        game.update_user_score(:away)
      end

      game.save!
    end

    head :no_content
  end
end
