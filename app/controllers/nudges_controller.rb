class NudgesController < ApplicationController
  def create
    challenge = current_user.outgoing_challenges.find(params[:challenge_id])
    challenge.send_reminder

    redirect_to challenges_path
  end
end
