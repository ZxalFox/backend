class ApplicationController < ActionController::API
    before_action :authenticate_user
  
    attr_reader :current_user
  
    private
  
    def authenticate_user
      token = request.headers['Authorization']&.split(' ')&.last
      if token
        decoded = JwtService.decode(token)
        @current_user = User.find(decoded[:user_id]) if decoded
      end
  
      render json: { error: "Não autorizado" }, status: :unauthorized unless @current_user
    end
  end