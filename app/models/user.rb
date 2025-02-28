class User < ApplicationRecord
    has_secure_password
    has_one :cart
    has_many :orders
  
    validates :email, presence: true, uniqueness: true
    validates :role, presence: true
  end