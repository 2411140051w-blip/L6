require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "index displays products and delete links" do
    get products_path

    assert_response :success
    assert_select "p", text: /商品名： MyString/
    assert_select "a[href='#{product_path(products(:one))}']", text: "削除"
  end

  test "index links to the current cart" do
    post cartitems_path, params: {
      cart_item: { product_id: products(:one).id, qty: 4 }
    }
    cart_item = CartItem.find_by!(product: products(:one), qty: 4)

    get products_path

    assert_response :success
    assert_select "a[href='#{cart_path(cart_item.cart_id)}']", text: "カートの内容を見る"
  end

  test "new renders the product form" do
    get new_product_path

    assert_response :success
    assert_select "form[action='#{products_path}']"
    assert_select "input[name='product[name]']"
    assert_select "input[name='product[price]']"
  end

  test "create saves a product" do
    assert_difference "Product.count", 1 do
      post products_path, params: { product: { name: "Tea", price: 250 } }
    end

    assert_redirected_to products_path
  end

  test "destroy deletes a product" do
    product = products(:one)

    assert_difference "Product.count", -1 do
      delete product_path(product)
    end

    assert_redirected_to products_path
  end

  test "destroy removes the product from carts" do
    product = Product.create!(name: "Temporary", price: 100)
    cart_item = CartItem.create!(
      product: product,
      cart: Cart.create!,
      qty: 1
    )

    delete product_path(product)

    assert_redirected_to products_path
    assert_not CartItem.exists?(cart_item.id)
  end
end
