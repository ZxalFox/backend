require 'stripe'

module Api
  module V1
    class PaymentsController < ApplicationController
      def create
        Stripe.api_key = ENV.fetch('STRIPE_SECRET_KEY', nil)

        # Criando um PaymentIntent no Stripe
        payment_intent = Stripe::PaymentIntent.create(
          amount: params[:amount], # Em centavos
          currency: 'brl',
          metadata: { user_id: current_user.id }
        )

        render json: { client_secret: payment_intent.client_secret }
      rescue Stripe::StripeError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end
  end
end
