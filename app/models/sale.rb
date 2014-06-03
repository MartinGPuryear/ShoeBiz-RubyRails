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

end
