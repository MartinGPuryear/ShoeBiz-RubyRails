module SessionsHelper

  ADMIN_ID = 1

  def sign_in(user)
    session[:user_id] = user.id
    self.current_user = user
  end
  def sign_out
    session[:user_id] = nil
    self.current_user = nil
  end

  # setter method
  def current_user=(user)
    @current_user = user
  end
  # getter method
  def current_user
    @current_user ||= User.select(:id, :first_name, :last_name, :email, :created_at).find(session[:user_id]) if session[:user_id]
  end

  def signed_in?
    !current_user.nil?
  end
  def current_user?(user)
    user == current_user 
  end
  def admin?(user)
    user.id == ADMIN_ID
  end

  def deny_not_signed_in
    redirect_to signin_path, notice: "Please sign in to access that page."
  end
  def deny_wrong_user
    redirect_to signin_path, notice: "Cannot access that page while signed in as a different user."
  end
  def deny_not_admin
    redirect_to signin_path, notice: "Cannot access that page while signed in as a different user."
  end

end
