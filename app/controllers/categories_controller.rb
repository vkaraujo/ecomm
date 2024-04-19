class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @products = @category.products
                         .max_price(price_params[:max])
                         .min_price(price_params[:min])
  end

  private

  def price_params
    params.permit(:max, :min)
  end
end
