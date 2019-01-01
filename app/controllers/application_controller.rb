class ApplicationController < ActionController::API
    # include Knock::Authenticable
    # undef_method :current_user
    acts_as_token_authentication_handler_for User, fallback: :none

end