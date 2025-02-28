class ApplicationController < ActionController::API
  before_action :authorize_request, except: :create

  def authorize_request
    header = request.headers['Authorization']
    header = header.split.last if header
    begin
      decoded = JWT.decode(header, Rails.application.secrets.secret_key_base)[0]
      @current_user = User.find(decoded['user_id'])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { error: 'Token inválido ou expirado' }, status: :unauthorized
    end
  end
end
