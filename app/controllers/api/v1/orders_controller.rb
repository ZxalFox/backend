module Api
  module V1
    class OrdersController < ApplicationController
      def create
        payment_intent = Stripe::PaymentIntent.retrieve(params[:payment_intent_id])

        if payment_intent.status != 'succeeded'
          return render json: { error: 'Pagamento não aprovado' }, status: :unprocessable_entity
        end

        cart = Cart.find_by(user_id: @current_user.id)

        order = Order.create!(
          user: @current_user,
          total: cart.total_price_cents,
          status: 'paid',
          payment_intent_id: payment_intent.id
        )

        # Mover itens do carrinho para o pedido
        cart.cart_items.each do |cart_item|
          order.order_items.create!(
            product: cart_item.product,
            quantity: cart_item.quantity,
            price: cart_item.product.price
          )
        end

        # Esvaziar o carrinho
        cart.cart_items.destroy_all

        render json: { order: order }, status: :created
      rescue Stripe::StripeError => e
        render json: { error: e.message }, status: :unprocessable_entity
      rescue ActiveRecord::RecordInvalid => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end
  end
end
