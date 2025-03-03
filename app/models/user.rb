class User < ApplicationRecord
  has_secure_password
  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy

    
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true
  end