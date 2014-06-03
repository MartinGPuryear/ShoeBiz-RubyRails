class UsersController < ApplicationController

  #   Manages the creation and update of user registrations.
  #   - Creating an acct uses :new and :create.  
  #   - Viewing the users list uses :index.
  #   - Viewing a user dashboard uses :show.
  #   - Editing a user profile uses :edit and :update.
  #  
  #   Admin access is required for the remaining RESTful 
  #   CRUD functionality (:destroy, which removes a user).
  #   
  #   Except when creating a new user account, the user must
  #   be signed in when using these functions.  As mentioned
  #   above, user must be Admin to use :destroy.
  # 
  #   Unlike a Session, a User object IS backed by a model.  
  #
  #   SessionsHelper provides numerous companion functions to
  #   track current user, creating a User subset that can be 
  #   passed to views (i.e. without password). Also contains
  #   functions to check whether signed-in, whether admin, 
  #   or whether user "owns" user-specific views requested. 

  before_action :require_signin, except: [:new, :create]
  before_action :require_user_exists, only: [:show, :edit, :update, :destroy]

  def index
    current_user

    @users = User.select(:id, :first_name, :last_name, :email, :created_at).all
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if !user.save      
      user.errors.full_messages.each_index{ |idx| flash["error-#{idx}"] = "#{user.errors.full_messages[idx]}" }
      
      redirect_to new_user_path, error: "User could not be created."
    else
      if (signed_in? && admin?(current_user))
        redirect_to users_path, notice: "User was successfully created."
      else
        @user = User.select(:id, :first_name, :last_name, :email, :created_at).find(user.id)
        sign_in @user
        redirect_to user_path(@user.id), notice: "Your account was successfully created."
      end
    end
  end

  def show
    if !user_exists?(params[:id])
      deny_user_not_found
      # return
    else
      @user = User.select(:id, :first_name, :last_name, :email, :created_at).find(params[:id])
      current_user
      
      my_prods = Product.all.where(seller_id: @user.id)
      @sales = my_prods.reject{|p| p.sale.nil? }
      @offers = my_prods - @sales
      @purchases = Sale.all.where(buyer_id: @user.id).collect{|s| s.product}
    end
  end

  def edit
    if !signed_in? 
      deny_not_signed_in
    elsif !user_exists?(params[:id])
      deny_user_not_found
    end

    @user = User.select(:id, :first_name, :last_name, :email, :created_at).find(params[:id])
    if !current_user?(@user) && !admin?(current_user)
      deny_wrong_user
    end

  end

  def update
    user = User.find(params[:id])
    if user.update(user_params) == false      
      user.errors.full_messages.each_index{ |idx| flash["error-#{idx}"] = "#{user.errors.full_messages[idx]}" }
      redirect_to edit_user_path(user.id), error: "User could not be updated."
    else
      redirect_to user_path(user.id), notice: "User was successfully updated."
    end
    
  end

  def destroy
    user = User.find(params[:id])
    
    if current_user?(user)
      flash[:error] = "You really shouldn't delete yourself - it isn't healthy!"
    elsif user.destroy == false
      user.errors.full_messages.each_index{ |idx| flash["error-#{idx}"] = "#{user.errors.full_messages[idx]}" }
    end

    redirect_to users_path
  end


  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end