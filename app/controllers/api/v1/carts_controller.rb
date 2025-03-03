module Api
  module V1
    class CartsController < ApplicationController
      before_action :set_cart, only: [:show]

      # GET /api/v1/cart
      def show
        render json: @cart, include: { cart_items: { include: :product } }, methods: :total_price_cents
      end
      

      private

      def set_cart
        @cart = current_user.cart || current_user.create_cart
      end
    end
  end
  end