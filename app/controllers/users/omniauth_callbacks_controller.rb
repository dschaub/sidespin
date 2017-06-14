class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user && @user.active_for_authentication? && @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Google"
      sign_in_and_redirect @user, event: :authentication
    else
      flash[:error] = "Unable to sign in! Make sure you're using your betterment.com account."
      redirect_to root_path
    end
  end
end
