class Api::RfidTagReadsController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    @live_game = LiveGame.current
    player = User.find_by_tag_id(params[:tag_id])

    if player.nil?
      render :text => "User not found.", :status => 404
    end

    if @live_game.present?
      @live_game.away_user = player
      @live_game.save
    else
      @live_game = LiveGame.new
      @live_game.update_attribute(:home_user_id, player.id)
    end

    head :ok
  end
end
