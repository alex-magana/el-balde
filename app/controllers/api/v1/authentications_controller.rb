module Api
  module V1
    class AuthenticationsController < ApplicationController
      before_action :authenticate_request!, except: [:login]
      before_action :set_user, only: [:login]

      attr_reader :user

      def login
        if @user && @user.authenticate(params[:password])
          manage_token
        else
          render_response({ error: invalid_login_credentials }, :unauthorized)
        end
      end

      def logout
        token_valid = Authentication.invalidate_token(current_user, true)
        unless !token_valid
          render_response({ message: logout_successful }, :ok)
        end
      end

      private

      def set_user
        @user = User.find_by(email: login_params[:email].to_s.downcase)
      end

      def login_params
        params.permit(:email, :password)
      end

      def commence_session
        auth_token = JsonWebToken.encode(user_id: @user.id)
        render_response({ auth_token: auth_token, message: login_successful },
                        :ok)
      end

      def resume_session(token)
        render_response({ auth_token: token, message: already_logged_in },
                        :ok)
      end

      def manage_token
        authentication = Authentication.search_valid_token(@user)
        if authentication
          resume_session(authentication.token)
        else
          commence_session
        end
      end
    end
  end
end
