class ChallengesController < ApplicationController

  def index
    @incoming_challenges = current_user.incoming_challenges
    @outgoing_challenges = current_user.outgoing_challenges
  end
end
