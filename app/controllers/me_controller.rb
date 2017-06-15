class MeController < ApplicationController
  def show
    @user = current_user
  end

  def update
    current_user.update!(update_params)
    redirect_to me_path
  end

  private

  def update_params
    params.require(:user).permit(:slack_user_name)
  end
end
