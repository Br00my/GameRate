class OauthCallbacksController < Devise::OmniauthCallbacksController
  def steam
    @user = User.find_by(id: auth[:uid])

    set_flash_message(:notice, :success, username: auth[:info][:nickname]) if is_navigational_format?

    unless @user
      @user = User.create!(id: auth[:uid], username: auth[:info][:nickname])
      if SteamCov.profile_public?(auth[:uid])
        AddOwnedGamesService.new(@user).call
      else
        flash[:notice] += "Make your account public"
      end
    end

    sign_in_and_redirect @user
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end