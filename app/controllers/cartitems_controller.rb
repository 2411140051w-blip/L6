class CartitemsController < ApplicationController
    def new
        @product = Product.find(params[:product_id])
        @cartitem = CartItem.new(product: @product, qty: 1)
    end

    def create
        cart_item_params = params.require(:cart_item).permit(:product_id, :qty)
        @product = Product.find(cart_item_params[:product_id])
        cart = Cart.find_by(id: session[:cart_id])
        unless cart
            cart = Cart.create!
            session[:cart_id] = cart.id
        end

        @cartitem = CartItem.new(
            cart: cart,
            product: @product,
            qty: cart_item_params[:qty]
        )
        if @cartitem.save
            flash[:notice] = '商品を追加しました'
            redirect_to products_path
        else
            render :new, status: :unprocessable_content
        end
    end

    def destroy
        cart = Cart.find_by(id: session[:cart_id])
        unless cart
            redirect_to products_path, alert: 'カートが見つかりません'
            return
        end

        cart_item = cart.cart_items.find(params[:id])
        if cart_item.destroy
            redirect_to cart_path(cart), notice: '商品をカートから削除しました'
        else
            redirect_to cart_path(cart), alert: '削除に失敗しました'
        end
    end
end
