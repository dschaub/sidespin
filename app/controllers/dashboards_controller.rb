class DashboardsController < ApplicationController
  def show
    if user_signed_in?
      @simple_match = current_user.build_simple_match
    end
  end
end
