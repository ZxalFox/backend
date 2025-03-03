module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authorize_request, only: [:create] # Permite signup sem autenticação
      before_action :set_user, only: %i[show update]

      def show
        render json: @user
      end

      def create
        @user = User.new(user_params)
        if @user.save
          render json: { message: 'Usuário criado com sucesso!' }, status: :created
        else
          render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @user.update(user_params)
          render json: @user
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:email, :password, :role, :name)
      end
    end
  end
end
