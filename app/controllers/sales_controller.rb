class SalesController < ApplicationController

  #   The Sales object records when a buyer has accepted a
  #   product offering from a seller.  Because Sales are
  #   generally not alterable after the fact, there are no
  #   edit/update methods, and because the act of buying
  #   is a simple click, there need be no new method. 
  #   Methods index, create and destroy are sufficient.  
  #
  #   In this case the create method is non-standard, as
  #   it requires an input parameter for the associated
  #   product ID.
  # 
  #   Viewing/creating/deleting a sale requires a signed-
  #   in user. In this system, any signed-in user can view 
  #   all users, product offerings and previous sales.  
  #
  #   In reality, deleting a sale after the fact would
  #   really need to be supported by business goals
  #   (since it could definitely lead to mistrust in the
  #   minds of sellers or buyers!), but in this case it
  #   exists simply to demonstrate technology expertise.  

  include ProductsHelper

  before_action :require_signin
  before_action :require_product_exists, only: [:create]

  def index
    @sales = Sale.all
  end

  def create
    @sale = Sale.new(product_id: params[:id], buyer_id: current_user.id).save
    
    redirect_to products_path    
  end

  def destroy
    sale = Sale.find(params[:id])
    
    if !current_user?(sale.buyer) && !current_user?(sale.product.seller) && !admin?(current_user)
      flash[:error] = "You cannot remove sales that are not yours."
    elsif sale.destroy == false
      sale.errors.full_messages.each_index{ |idx| flash["error-#{idx}"] = "#{sale.errors.full_messages[idx]}" }
    end

    redirect_to products_path    
  end
end
