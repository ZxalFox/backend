module Api
  module V1
    class CheckoutController < ApplicationController
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']

      def create
        cart = Cart.find_by(user_id: @current_user.id)

        if cart.nil? || cart.cart_items.empty?
          return render json: { error: 'Carrinho vazio' }, status: :unprocessable_entity
        end

        amount_cents = (cart.total_price_cents * 100).to_i

        # Criar um PaymentIntent no Stripe
        payment_intent = Stripe::PaymentIntent.create(
          amount: amount_cents, # Certifique-se de que `total_price_cents` retorna o total em centavos
          currency: 'brl',
          payment_method_types: ['card'],
          metadata: { user_id: @current_user.id }
        )

        render json: { client_secret: payment_intent.client_secret, payment_intent_id: payment_intent.id }, status: :ok
      rescue Stripe::StripeError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def confirm_payment
        payment_intent = Stripe::PaymentIntent.retrieve(params[:payment_intent_id])

        if payment_intent.status == 'succeeded'
          order = Order.create(user: current_user, total_price: payment_intent.amount / 100)
          current_user.cart.cart_items.destroy_all # Limpa o carrinho
          render json: { message: 'Pedido criado com sucesso!', order: order }, status: :ok
        else
          render json: { error: 'Pagamento não confirmado' }, status: :unprocessable_entity
        end
      end
    end
  end
end
