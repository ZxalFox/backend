class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  # Calcula o valor total do carrinho
  def total_price_cents
    cart_items.sum { |item| item.product.price * item.quantity }
  end
end