class ChallengesController < ApplicationController

  def index
    @incoming_challenges = current_user.incoming_challenges.pending
    @outgoing_challenges = current_user.outgoing_challenges.pending
  end

  def new
    @challenge = current_user.outgoing_challenges.build
  end

  def create
    @challenge = current_user.outgoing_challenges.build(challenge_params)
    if @challenge.save
      redirect_to challenges_path
    else
      render :new
    end
  end

  private

  def challenge_params
    params.require(:challenge).permit(:away_user_id)
  end
end
