class Admin < ActiveRecord::Base

  #   Admin  is the data record/model for whether a user is a system admin.
  #   Specifically, the presence of this record is the indication that the
  #   user is a system administrator.  

  #   Admin_user_id binds the record to its user.

  #   Basic validation ensures admin_user_id is set.

  belongs_to :admin_user, class_name: "User"
  validates  :admin_user_id, presence: true

end
