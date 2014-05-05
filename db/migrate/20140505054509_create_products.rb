class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.float :amount
      t.references :seller, index: true, class_name: "User"

      t.timestamps
    end
  end
end
