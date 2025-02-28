module Api
  module V1
    class OrdersController < ApplicationController
      before_action :set_order, only: [:show]

      # GET /api/v1/orders
      def index
        @orders = current_user.orders
        render json: @orders
      end

      # GET /api/v1/orders/:id
      def show
        render json: @order
      end

      # POST /api/v1/orders
      def create
        @cart = current_user.cart
        return render json: { error: 'Carrinho vazio' }, status: :unprocessable_entity if @cart.cart_items.empty?

        @order = build_order

        if @order.save
          process_order_items
          clear_cart
          render json: @order, status: :created
        else
          render json: @order.errors, status: :unprocessable_entity
        end
      end

      private

      def set_order
        @order = Order.find(params[:id])
      end

      def build_order
        current_user.orders.new(
          total_amount: @cart.total_amount,
          status: 'pending',
          stripe_payment_id: params[:order][:stripe_payment_id]
        )
      end

      def process_order_items
        @cart.cart_items.each do |item|
          @order.order_items.create(
            product: item.product,
            quantity: item.quantity,
            price: item.product.price
          )
        end
      end

      def clear_cart
        @cart.cart_items.destroy_all
      end
    end
  end
end
