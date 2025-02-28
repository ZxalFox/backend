class Product < ApplicationRecord
    has_many :cart_items, dependent: :destroy
    has_many :order_items, dependent: :destroy
  
    validates :name, presence: true
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  end