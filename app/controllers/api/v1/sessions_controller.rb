module Api
  module V1
    class SessionsController < ApplicationController
      def create
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = JwtService.encode(user_id: user.id)
          render json: { token: token }
        else
          render json: { error: 'Email ou senha inválidos' }, status: :unauthorized
        end
      end
    end
  end
  end