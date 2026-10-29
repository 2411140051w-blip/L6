class Product < ApplicationRecord
    has_many :cartitem
    has_many :cartitem_carts, through: :cartitems, source: :cart
end
