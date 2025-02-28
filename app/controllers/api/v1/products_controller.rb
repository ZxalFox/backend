module Api
  module V1
    class ProductsController < ApplicationController
      skip_before_action :authorize_request, only: %i[index show] # Permite listar e ver produtos sem login
      
      def index
        @products = Product.all
        render json: @products
      end

      def show
        @product = Product.find(params[:id])
        render json: @product
      end

      def create
        @product = Product.new(product_params)
        if @product.save
          render json: @product, status: :created
        else
          render json: @product.errors, status: :unprocessable_entity
        end
      end

      private

      def product_params
        params.require(:product).permit(:name, :price, :description, :stock)
      end
    end
  end
end
