module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :authorize_request, only: [:create]

      def create
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = JwtService.encode(user_id: user.id)
          render json: { token: token, user: user }, status: :ok
        else
          render json: { error: 'Credenciais inválidas' }, status: :unauthorized
        end
      end
    end
  end
end
