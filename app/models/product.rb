class Product < ActiveRecord::Base

  #   Product is the data record/model for an item offered for sale.
  #   As such, it has a many-one relationship with User.  That is,
  #   an user can have many products for sale.  

  #   Seller_id binds the record to the user that is offering it. 
  #   Name, amount and description round out the offering.

  #   Basic validation ensures name, amount and seller_id are set,
  #   and that amount is non-negative.

  belongs_to :seller,    class_name: "User"
  has_one    :sale,      dependent:  :destroy

  validates  :name,      presence: true
  validates  :amount,    presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates  :seller_id, presence: true

  class << self

    def get_purchases_by_user(purchaser_id)
      my_purchases = joins(:seller, :sale).
                     where("sales.buyer_id = ?", purchaser_id).
                     select("products.amount AS prod_amt, products.created_at AS post_date, products.id AS prod_id, products.name AS prod_name, sales.created_at AS sale_date, sales.id AS sale_id, seller_id, users.first_name || ' ' || users.last_name AS seller_name").
                     order(:id)
    end

    def get_offers_by_user(offerer_id)
      my_offers = includes(:sale).
                  where(seller_id: offerer_id).
                  where(sales: {product_id: nil}).
                  order(:id)
    end

    def get_product_by_id(product_id)
      product = joins(:seller).
                select("products.amount, products.created_at, products.description, products.id, products.name AS prod_name, seller_id, users.first_name || ' ' || users.last_name AS seller_name").
                find(product_id)
    end

  end

end
