module Api
  module V1
    class OrderItemsController < ApplicationController
      before_action :set_order

      # GET /api/v1/orders/:order_id/items
      def index
        render json: @order.order_items, include: :product
      end

      private

      def set_order
        @order = current_user.orders.find_by(id: params[:order_id])
        render json: { error: 'Pedido não encontrado' }, status: :not_found unless @order
      end
    end
  end
  end
  