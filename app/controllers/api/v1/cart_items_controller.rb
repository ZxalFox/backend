module Api
    module V1
      class CartItemsController < ApplicationController
        before_action :set_cart_item, only: [:update, :destroy]
  
        # POST /api/v1/cart/items
        def create
          @cart = Cart.find_or_create_by(user_id: current_user.id)
          @cart_item = @cart.cart_items.new(cart_item_params)
          if @cart_item.save
            render json: @cart_item, status: :created
          else
            render json: @cart_item.errors, status: :unprocessable_entity
          end
        end
  
        # PUT /api/v1/cart/items/:id
        def update
          if @cart_item.update(cart_item_params)
            render json: @cart_item
          else
            render json: @cart_item.errors, status: :unprocessable_entity
          end
        end
  
        # DELETE /api/v1/cart/items/:id
        def destroy
            @cart_item = CartItem.find(params[:id])
            if @cart_item.destroy
              head :no_content
            else
              render json: { error: "Não foi possível remover o item do carrinho" }, status: :unprocessable_entity
            end
          end
  
        private
  
        def set_cart_item
          @cart_item = CartItem.find(params[:id])
        end
  
        def cart_item_params
          params.require(:cart_item).permit(:product_id, :quantity)
        end
      end
    end
  end