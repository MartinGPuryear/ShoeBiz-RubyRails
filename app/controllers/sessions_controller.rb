class SessionsController < ApplicationController

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
