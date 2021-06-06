class OauthCallbacksController < Devise::OmniauthCallbacksController
  skip_forgery_protection with: :null_session
  def steam
    @user = User.find_by(uid: auth[:uid].to_s)

    unless @user&.persisted?
      @user = User.create(username: auth[:info][:nickname], uid: auth[:uid])
    end

    sign_in_and_redirect @user
    set_flash_message(:notice, :success, username: auth[:info][:nickname]) if is_navigational_format?
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end