class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|

      t.references :admin_user, index: true, class_name: "User"
      t.timestamps
    end
  end
end
