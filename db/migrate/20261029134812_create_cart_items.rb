class CreateCartItems < ActiveRecord::Migration[8.1]
  def change
    create_table :cart_items do |t|
      t.integer :qty
      t.integer :product_id
      t.integer :cart_id

      t.timestamps
    end
  end
end
