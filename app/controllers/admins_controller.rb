class AdminsController < ApplicationController

  #   The Admin record is a token that indicates that the 
  #   specified user has admin privileges.  Hence, the only
  #   methods needed are create and destroy.  An index
  #   method is included as well, for an admin-style users
  #   view.  All three of these methods require a signed-
  #   in user with admin privileges.
  #   
  #   In this case the create method is non-standard, as
  #   it requires an input parameter for the associated
  #   user ID.

  before_action :require_signin
  before_action :require_admin
  before_action :require_user_exists, only: [:create]

  def index
    @admin_users = Admin.all.map{ |a| a.admin_user }
    @users = User.all - @admin_users
  end

  def create
    user = User.find(params[:id])
    if !user.admin.nil?
      flash[:notice] = "User was already an Admin."
    else
      user.admin = Admin.new
      flash[:error] = "Admin record could not be created." if user.admin.nil?
    end
    redirect_to :back
  end

  def destroy
    admins = Admin.where(admin_user_id: params[:id])

    if !admins.length
      flash[:error] = "User was not an admin - cannot demote."
    elsif admins.length > 1
      flash[:notice] = "More than one Admin record with this user_id was found!  Deleted all of them."
    end
    admins.each{ |admin|  if !admin.destroy 
                            flash[:error] = "Could not destroy Admin record."
                          end 
                }
    redirect_to :back
  end
end
