require "test_helper"

class CartitemsControllerTest < ActionDispatch::IntegrationTest
  test "new displays selected product details" do
    product = products(:one)

    get new_cartitem_path(product_id: product.id)

    assert_response :success
    assert_includes response.body, product.name
    assert_includes response.body, product.price.to_s
    assert_select "input[name='cart_item[product_id]'][value='#{product.id}']"
  end

  test "create adds a product to a cart" do
    product = products(:one)

    assert_difference "CartItem.count", 1 do
      post cartitems_path, params: {
        cart_item: { product_id: product.id, qty: 2 }
      }
    end

    cart_item = CartItem.find_by!(product: product, qty: 2)
    assert_redirected_to products_path
    follow_redirect!

    assert_response :success
    assert_includes response.body, product.name
    assert Cart.exists?(cart_item.cart_id)

    get cart_path(cart_item.cart_id)
    assert_response :success
    assert_includes response.body, (product.price * 2).to_s
  end

  test "cart total ignores items with missing products" do
    product = products(:one)
    post cartitems_path, params: {
      cart_item: { product_id: product.id, qty: 2 }
    }
    cart_item = CartItem.find_by!(product: product, qty: 2)
    cart_item.update_column(:product_id, -1)

    get cart_path(cart_item.cart_id)

    assert_response :success
    assert_includes response.body, 'この商品は削除されています。'
    assert_includes response.body, '合計金額：0円'
  end

  test "destroy removes a product from the current cart" do
    product = products(:one)
    post cartitems_path, params: {
      cart_item: { product_id: product.id, qty: 1 }
    }
    cart_item = CartItem.find_by!(product: product, qty: 1)

    assert_difference "CartItem.count", -1 do
      delete cartitem_path(cart_item)
    end

    assert_redirected_to cart_path(cart_item.cart_id)
    follow_redirect!

    assert_response :success
    assert_includes response.body, 'カートは空です。'
  end
end
