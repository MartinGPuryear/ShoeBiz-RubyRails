class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.references :buyer, index: true, class_name: "User"
      t.references :product, index: true

      t.timestamps
    end
  end
end
