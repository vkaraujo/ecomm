class CheckoutsController < ApplicationController
  def create
    cart_params = checkout_params[:cart]
    service = StripeCheckoutService.new(cart_params)
    result = service.create_session

    if result[:error]
      render json: { error: result[:error] }, status: result[:status]
    else
      render json: { url: result[:url] }
    end
  end

  def success
    render :success
  end

  def cancel
    render :cancel
  end

  private

  def checkout_params
    params.permit(cart: %i[id size quantity price name])
  end
end
