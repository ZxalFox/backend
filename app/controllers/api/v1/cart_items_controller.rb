module Api
  module V1
    class CartItemsController < ApplicationController
      before_action :set_cart_item, only: %i[update destroy]

      # POST /api/v1/cart/items
      def create
        unless @current_user
          Rails.logger.error 'Erro: Usuário não autenticado ao adicionar item ao carrinho'
          return render json: { error: 'Usuário não autenticado' }, status: :unauthorized
        end
      
        @cart = Cart.find_or_create_by(user_id: @current_user.id)
        @cart_item = @cart.cart_items.find_or_initialize_by(product_id: cart_item_params[:product_id])
        @cart_item.quantity = (@cart_item.quantity || 0) + cart_item_params[:quantity].to_i

      
        if @cart_item.save
          render json: @cart_item, status: :created
        else
          render json: @cart_item.errors, status: :unprocessable_entity
        end
      end           

      # PUT /api/v1/cart/items/:id
      def update
        if cart_item_params[:quantity].to_i < 1
          return render json: { error: 'Quantidade inválida' }, status: :unprocessable_entity
        end
      
        if @cart_item.update(cart_item_params)
          render json: @cart_item
        else
          render json: @cart_item.errors, status: :unprocessable_entity
        end
      end      

      # DELETE /api/v1/cart/items/:id
      def destroy
        if @cart_item.destroy
          head :no_content
        else
          render json: { error: 'Não foi possível remover o item do carrinho' }, status: :unprocessable_entity
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
