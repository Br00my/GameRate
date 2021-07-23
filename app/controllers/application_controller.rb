class ApplicationController < ActionController::Base
  before_action :set_gon_user, unless: :devise_controller?
  
  skip_forgery_protection with: :null_session

  private

  def set_gon_user
    gon.user_id = current_user&.id
  end
end
