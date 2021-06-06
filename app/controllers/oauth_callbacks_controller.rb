class OauthCallbacksController < Devise::OmniauthCallbacksController
  skip_forgery_protection with: :null_session
  def steam
    @user = User.find_by(uid: auth[:uid].to_s)

    if @user&.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: 'Steam') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end