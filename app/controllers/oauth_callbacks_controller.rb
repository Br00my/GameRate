class OauthCallbacksController < Devise::OmniauthCallbacksController
  skip_forgery_protection with: :null_session

  def steam
    @user = User.find_by(id: 76561199163469955)

    set_flash_message(:notice, :success, username: auth[:info][:nickname]) if is_navigational_format?

    unless @user
      @user = User.create!(id: 76561199163469955, username: auth[:info][:nickname])
      if SteamCov.profile_public?(76561199163469955)
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