module Api
    module V1
      class OrdersController < ApplicationController
        before_action :set_order, only: [:show]
  
        # POST /api/v1/orders
        def create
            @cart = current_user.cart
            @order = current_user.orders.new(
              total_amount: @cart.total_amount,
              status: "pending",
              stripe_payment_id: params[:order][:stripe_payment_id]
            )
          
            if @order.save
              @cart.cart_items.each do |item|
                @order.order_items.create(
                  product: item.product,
                  quantity: item.quantity,
                  price: item.product.price
                )
              end
              @cart.cart_items.destroy_all
              render json: @order, status: :created
            else
              render json: @order.errors, status: :unprocessable_entity
            end
          end
  
        # GET /api/v1/orders
        def index
          @orders = current_user.orders
          render json: @orders
        end
  
        # GET /api/v1/orders/:id
        def show
          render json: @order
        end
  
        private
  
        def set_order
          @order = Order.find(params[:id])
        end
      end
    end
  end