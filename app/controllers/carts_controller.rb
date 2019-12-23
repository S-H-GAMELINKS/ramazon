class CartsController < ApplicationController
  before_action :set_product

  def index
  end

  def create
    if current_user.carts.empty?
      @cart = current_user.carts.build
      @cart.save!
    else
      @cart = current_user.carts.last
    end
    @cart.add(@product, @product.price)
    @cart.save

    redirect_to @product
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def set_product
      @product = Product.find(params[:product_id])
    end
end