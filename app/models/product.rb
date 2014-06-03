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
  validates  :amount,    presence: true, numericality: { greater_than_or_equal_to: 0}
  validates  :seller_id, presence: true

end
