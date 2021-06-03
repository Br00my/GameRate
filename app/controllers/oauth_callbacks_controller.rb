class OauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: [:steam]
  def steam
    @user = FindForOauthService.new(auth).call

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