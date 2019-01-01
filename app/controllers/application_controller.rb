class ApplicationController < ActionController::API
    # include Knock::Authenticable
    # undef_method :current_user

    # Header를 자동으로 가져와주는 기능을 하지만 JWT를 사용하면서 직접 헤더에 접근해서 토큰을 가져와야 한다.
    # acts_as_token_authentication_handler_for User, fallback: :none

    def current_user
        # 캐시에 저장.
        # User를 로드하면 캐시에 저장하여 한 번만 로드를 하고, 다음 요청에 대해서 응답한다.
        @current_user ||= User.find(payload['user_id'])
    end


    private

    def payload
        JWT.decode(get_token, Rails.application.credentials.secret_key_base, true, {algorithm: 'HS256'}).first
    end

    # Header의 Authorization에서 토큰을 가져오는 것
    def get_token
        request.headers['Authorization'].split(' ').last
    end

    # head에 포함되어 있는 토큰을 가져다가 User 객체를 가져오는 메서드


end