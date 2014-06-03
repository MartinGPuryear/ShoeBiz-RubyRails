module SessionsHelper

  #   SessionsHelper provides utility functions for sessions and 
  #   users. It can check if a session is signed in, if a given user 
  #   exists, if the signed-in user is an admin, and whether the 
  #   user can access user-specific info.
  #   Additionally, it creates the current_user instance: a subset
  #   of the User record that is safe to pass to views (we shouldn't
  #   pass encrypted_password or salt). 


public
  #   Track this user_id in our session list, and set current_user.
  def sign_in(user)
    session[:user_id] = user.id
    current_user
  end
  #   Undo sign_out: forget this session and current_user.
  def sign_out
    session[:user_id] = nil
    @current_user = nil
  end

  #   Retrieve (a safe subset of) the currently signed-in user.
  def current_user
    @current_user ||= User.select(:id, :first_name, :last_name, :email, :created_at).find(session[:user_id]) if session[:user_id]
  end

  #   Is the current session signed in yet?  
  def signed_in?
    !current_user.nil?
  end
  #   Is this passed-in user the currently signed-in user?
  def current_user?(user)
    user == current_user 
  end
  #   Does this passed-in user have administrator privileges? 
  def admin?(user)
    user.admin.nil? == false
  end
  #   Does the passed-in user exist (even if not signed-in)?
  def user_exists?(user_id)
    User.where(id: user_id).length > 0
  end

  #   Handle cases where user is not signed in, but should be.
  def deny_not_signed_in
    flash[:error] = "Please sign in to access that page."
    redirect_to signin_path
  end
  #   Handle cases where this user_id does not exist.
  def deny_user_not_found
    flash[:error] = "User is not found."
    redirect_to users_path
  end
  #   Handle cases where a user can't access another user's info.
  def deny_wrong_user
    flash[:error] = "Access denied - cannot access other users' information."
    redirect_to :back
  end
  #   Handle cases where user is not an administrator, but should be.
  def deny_not_admin
    
    flash[:error] = "Access denied - only admins can access that page."
    redirect_to :back if HTTP_REFERER
    redirect_to signin_path if !HTTP_REFERER

  end

  #   If signed in, continue on. Otherwise, redirect to signin.
  def require_signin
    deny_not_signed_in unless signed_in?
  end
  #   If signed in, continue on. Otherwise, redirect to signin.
  def require_user_exists
    deny_user_not_found unless user_exists?(params[:id])
  end
  #   If this user is you (or you are admin), continue. Else, redirect to signin.
  def require_current_user(user)
    if !signed_in?
      deny_access
    elsif (!current_user?(user) && !admin?(current_user))
      deny_wrong_user
    end
  end
  #   If admin, continue on. Otherwise, redirect to profile.
  def require_admin
    if !signed_in?
      deny_access
    elsif !admin?(current_user)
      deny_not_admin
    end
  end

end
