class ProductsController < ApplicationController
  def index
    if !signed_in?
      deny_not_signed_in
    end

    @products = Product.all
  end

  def new
    @product = Product.new(seller_id: current_user.id)
  end

  def show
    if !signed_in? 
      deny_not_signed_in
    end
    
    @product = Product.find(params[:id])
  end

  def edit
    @product = Product.find(params[:id])

    if !current_user?(@product.seller) && !admin?(current_user)
      deny_wrong_user
    end
  end

  def create
    product = Product.new(product_params)
    if !product.save      
      product.errors.full_messages.each_index{ |idx| flash["error-#{idx}"] = "#{product.errors.full_messages[idx]}" }
      redirect_to new_product_path, error: 'Product could not be created.'
    else
      redirect_to product_path(product.id), notice: 'Product was successfully created.'
    end
  end

  def update
    product = Product.find(params[:id])
    if !current_user?(product.seller)
      redirect_to products_path, notice: "You cannot edit product listings that are not yours."
    elsif product.update(product_params) == false      
      product.errors.full_messages.each_index{ |idx| flash["error-#{idx}"] = "#{product.errors.full_messages[idx]}" }
      redirect_to edit_product_path(product.id), error: 'Product could not be updated.'
    else
      redirect_to product_path(product.id), notice: 'Product was successfully updated.'
    end
  end

  def destroy
    product = Product.find(params[:id])
    
    if !current_user?(product.seller)
      redirect_to products_path, notice: "You cannot remove product listings that are not yours."
    elsif product.destroy == false
      product.errors.full_messages.each_index{ |idx| flash["error-#{idx}"] = "#{product.errors.full_messages[idx]}" }
    end

    redirect_to products_path
  end


  private
  def product_params
    params.require(:product).permit(:name, :amount, :seller_id)
  end
end