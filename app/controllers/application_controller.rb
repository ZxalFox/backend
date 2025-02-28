class ApplicationController < ActionController::API
  before_action :authorize_request

  attr_reader :current_user

  private

  def authorize_request
    header = request.headers['Authorization']
    token = header.split.last if header.present?

    decoded_token = JwtService.decode(token)

    if decoded_token
      @current_user = User.find_by(id: decoded_token[:user_id])
      render json: { error: 'Usuário não encontrado' }, status: :unauthorized unless @current_user
    else
      render json: { error: 'Token inválido ou expirado' }, status: :unauthorized
    end
  end
end
