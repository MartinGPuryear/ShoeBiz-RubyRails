class SessionsController < ApplicationController

  #   Manages the signin/signout process for already-registered users.
  #   Only :new, :create and :destroy are used.  
  # 
  #   Note that the Session object is not backed by a model.  
  #   Possible future features: (index) listing those currently signed-in, 
  #   (show) details about a session, or (edit/update) changing aspects
  #   of a login session while it is active.  

  #   SessionsHelper provides numerous companion functions for tracking
  #   the current user, creating a subset of the User object that is 
  #   passable to views (e.g. without password and salt). Also contains
  #   functions for checking if session is signed-in, whether current user 
  #   is admin, or whether user "owns" the user-specific views requested. 

  before_action :require_signin, only: [:destroy]

  def new
  end
  
  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
      flash.now[:error] = "Invalid email/password combination."
      render :new
    else
      sign_in user
      redirect_to user
    end
  end
  def destroy
    user = User.find(params[:id])
    if current_user?(user)
      sign_out
      redirect_to signin_path
    else
      flash[:error] = "User ID not valid."
      redirect_to :back
    end
  end

end
