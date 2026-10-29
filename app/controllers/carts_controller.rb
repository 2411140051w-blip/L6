class CartsController < ApplicationController
    def show
        @cart = Cart.find_by(id: session[:cart_id])
        @cart_items = @cart ? @cart.cart_items.includes(:product) : []
    end
end
