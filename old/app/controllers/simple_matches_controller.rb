class SimpleMatchesController < AuthenticatedController
  def create
    @simple_match = current_user.build_simple_match match_params

    if @simple_match.save
      flash[:success] = 'Your match has been saved!'
      redirect_to dashboard_path
    else
      render 'dashboards/show'
    end
  end

  private

  def match_params
    params.require(:simple_match).permit(:player_one_name, :player_two_name, :player_one_score, :player_two_score)
  end
end