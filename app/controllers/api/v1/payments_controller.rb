require 'stripe'

module Api
  module V1
    class PaymentsController < ApplicationController
      def create
        Stripe.api_key = Rails.application.credentials.stripe[:secret_key]

        # Cria uma cobrança no Stripe
        charge = Stripe::Charge.create(
          amount: params[:amount], # Valor em centavos (ex: 20997 para 209.97 BRL)
          currency: params[:currency], # Moeda (ex: "brl")
          source: params[:source], # Token do cartão de teste do Stripe
          description: "Pagamento para o pedido #{params[:order_id]}"
        )

        # Atualiza o status do pedido para "paid"
        order = Order.find(params[:order_id])
        order.update(status: "paid", stripe_payment_id: charge.id)

        render json: { status: "success", charge: charge }
      rescue Stripe::StripeError => e
        render json: { status: "error", message: e.message }, status: :unprocessable_entity
      end
    end
  end
end