module ProductsHelper

  #   ProductsHelper provides validation functions for whether
  #   a product with the given ID exists.   
  #   I've moved them here, out of ProductsController, since 
  #   they do not 'catch URLs' like controller methods do.


  #   Does the passed-in product exist?
  def product_exists?(product_id)
    Product.where(id: product_id).length > 0
  end

  #   Handle cases where this product_id does not exist.
  def deny_product_not_found
    flash[:error] = "Product not found."
    redirect_to products_path
  end

  #   Redirect to products if this product_id doesn't exist.
  def require_product_exists
    deny_product_not_found unless product_exists?(params[:id])
  end

end
