class FindForOauthService
  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.find_by(provider: @auth[:provider], uid: @auth[:uid].to_s)
    return authorization.user if authorization
    return if @auth[:info][:email].nil?

    email = @auth[:info][:email]
    user = User.find_by(email: email)
    create_authorization(user, @auth) if user

    user
  end

  private

  def create_authorization(user, auth)
    user.authorizations.create(provider: auth[:provider], uid: auth[:uid])
  end
end