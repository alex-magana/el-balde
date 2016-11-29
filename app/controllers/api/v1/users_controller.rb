module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_request!, except: [:create]
      before_action :set_user, only: [:show, :update, :destroy]

      def show
        render_response(@user)
      end

      def create
        @user = User.new(user_params)
        if @user.save
          render_response(@user, :created, api_v1_user_url(@user))
        else
          render_response(@user.errors, :unprocessable_entity)
        end
      end

      def update
        if @user.update(user_params)
          render_response(@user)
        else
          render_response(@user.errors, :unprocessable_entity)
        end
      end

      def destroy
        @user.destroy
        render_response(message: user_deletion_successful)
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(
          :first_name,
          :last_name,
          :email,
          :password,
          :password_confirmation,
          :authentication_token
        )
      end
    end
  end
end
