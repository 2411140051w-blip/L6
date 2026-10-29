class ProductsController < ApplicationController
    def index
        @products = Product.all
        @cart = Cart.find_by(id: session[:cart_id])
    end

    def new
        @product = Product.new
    end

    def create
        @product = Product.new(name: params[:product][:name], price: params[:product][:price])
        if @product.save
            flash[:notice] = '商品を追加しました'
            redirect_to products_path #=>一覧ページにリダイレクトする
        else
            render :new, status: :unprocessable_content
        end
    end

    def destroy
        @product = product.find(params[:id])
        if @product.destroy
            flash[:notice] = '１レコード削除しました'
            redirect_to products_path
        else
            flash[:notice] = '削除に失敗しました'
        end
    end
end
