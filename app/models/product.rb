class Product < ActiveRecord::Base

  belongs_to :seller, class_name: "User"
  has_one   :sale,    dependent:  :destroy

  validates :name,    presence: true
  validates :amount,  numericality: { greater_than_or_equal_to: 0}

end
