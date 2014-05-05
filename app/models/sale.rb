class Sale < ActiveRecord::Base
  
  belongs_to :buyer, class_name: "User"
  belongs_to :product

end
