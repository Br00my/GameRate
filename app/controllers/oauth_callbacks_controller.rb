class OauthCallbacksController < Devise::OmniauthCallbacksController
  skip_forgery_protection with: :null_session
  def steam
    @user = User.find_by(id: auth[:uid])

    set_flash_message(:notice, :success, username: auth[:info][:nickname]) if is_navigational_format?

    unless @user
      @user = User.create(id: auth[:uid], username: auth[:info][:nickname])
      if profile_public?
        AddOwnedGamesService.new(@user).call
        flash[:notice] += "\nHere are the games we found in your profile"
      else
        flash[:alert] += "\nYour Steam profile is private. Make it public so we can list your purchased games"
      end
    end

    sign_in_and_redirect @user
  end

  private

  def profile_public?
    Steam::User.summary(auth[:uid])["communityvisibilitystate"] == 3
  end

  def auth
    request.env['omniauth.auth']
  end
end