class SalesController < ApplicationController
  def index
    if !signed_in?
      deny_not_signed_in
    end

    @sales = Sale.all
  end

  def create
    @sale = Sale.new(product_id: params[:id], buyer_id: current_user.id).save
    
    redirect_to products_path    
  end

  def destroy
    sale = Sale.find(params[:id])
    
    if !current_user?(sale.buyer) && !current_user?(sale.product.seller) && !admin?(current_user)
      redirect_to products_path, notice: "You cannot remove sales that are not yours."
    elsif sale.destroy == false
      sale.errors.full_messages.each_index{ |idx| flash["error-#{idx}"] = "#{sale.errors.full_messages[idx]}" }
    end

    redirect_to products_path    
  end
end
