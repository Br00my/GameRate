class ApplicationController < ActionController::Base
  skip_forgery_protection with: :null_session
end
