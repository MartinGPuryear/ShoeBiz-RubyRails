class UsersController < ApplicationController
  def index
    if !signed_in?
      deny_not_signed_in
    end

    @users = User.select(:id, :first_name, :last_name, :email, :created_at).all
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if !user.save      
      user.errors.full_messages.each_index{ |idx| flash["error-#{idx}"] = "#{user.errors.full_messages[idx]}" }
      
      redirect_to new_user_path, error: 'User could not be created.'
    else
      @user = User.select(:id, :first_name, :last_name, :email, :created_at).find(user.id)
      sign_in @user
      redirect_to @user, notice: 'User was successfully created.'
    end
  end

  def show
    if !signed_in? 
      deny_not_signed_in
    end
    
    @user = User.select(:id, :first_name, :last_name, :email, :created_at).find(params[:id])
    current_user

    # @product = Product.new
    # @sale = Sale.new

  end

  def edit
    @user = User.select(:id, :first_name, :last_name, :email, :created_at).find(params[:id])

    if !current_user?(@user) && !admin?(current_user)
      deny_wrong_user
    end

  end

  def update
    user = User.find(params[:id])
    if user.update(user_params) == false      
      user.errors.full_messages.each_index{ |idx| flash["error-#{idx}"] = "#{user.errors.full_messages[idx]}" }
      redirect_to edit_user_path(user.id), error: 'User could not be updated.'
    else
      redirect_to user_path(user.id), notice: 'User was successfully updated.'
    end
    
  end

  def destroy
    user = User.find(params[:id])
    
    if current_user?(user)
      flash[:notice] = "You really shouldn't delete yourself - it isn't healthy!"
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