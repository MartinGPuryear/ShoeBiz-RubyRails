class Sale < ActiveRecord::Base
  
  #   Sale is the data record/model for an item's completed sale.
  #   As such, it has a one-one relationship with Product. 
  
  #   Product_id binds the record to its product (and seller_id),
  #   and buyer_id completes the relationship.  

  #   Basic validation ensures buyer_id and product_id are set.

  belongs_to :buyer, class_name: "User"
  belongs_to :product

  validates :buyer_id,    presence: true
  validates :product_id,  presence: true

  #   Class methods
  class << self
    
    def get_combined_sales
      sales = joins({product: :seller}, :buyer).
              select("buyers_sales.first_name || ' ' || buyers_sales.last_name AS buyer_name, buyers_sales.id AS buyer_id, products.amount AS prod_amt, products.created_at AS post_date, products.id AS prod_id, products.name AS prod_name, sales.id, sales.created_at AS sale_date, users.first_name || ' ' || users.last_name AS seller_name, users.id AS seller_id").
              order("prod_id")
    end

    def get_sales_by_user(seller_id)
      my_sales = joins({product: :seller}, :buyer).
                 where("products.seller_id = ?", seller_id).
                 select("buyers_sales.first_name || ' ' || buyers_sales.last_name AS buyer_name, buyers_sales.id AS buyer_id, products.amount AS prod_amt, products.created_at AS post_date, products.id AS prod_id, products.name AS prod_name, sales.id, sales.created_at AS sale_date").
                 order("prod_id")
    end

  end
end
