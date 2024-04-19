class WebhooksController < ApplicationController
  skip_forgery_protection

  def stripe
    service = StripeWebhookService.new(request.body.read, request.env["HTTP_STRIPE_SIGNATURE"])
    result = service.process
    render json: result[:json], status: result[:status]
  end
end
