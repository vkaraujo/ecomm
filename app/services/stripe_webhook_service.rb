class StripeWebhookService
  def initialize(payload, sig_header)
    @payload = payload
    @sig_header = sig_header
    @endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_secret)
  end

  def process
    event = verify_signature
    return { status: 400, json: { error: "Invalid signature" } } if event.nil?

    case event.type
    when 'checkout.session.completed'
      handle_checkout_session_completed(event.data.object)
    else
      puts "Unhandled event type: #{event.type}"
    end

    { status: 200, json: { message: 'success' } }
  end

  private

  def verify_signature
    Stripe::Webhook.construct_event(@payload, @sig_header, @endpoint_secret)
  rescue JSON::ParserError, Stripe::SignatureVerificationError => e
    nil
  end

  def handle_checkout_session_completed(session)
    address = build_address(session["shipping_details"])
    order = create_order(session, address)
    process_line_items(session, order)
  end

  def build_address(shipping_details)
    if shipping_details
      "#{shipping_details['address']['line1']} #{shipping_details['address']['city']}, #{shipping_details['address']['state']} #{shipping_details['address']['postal_code']}"
    else
      ""
    end
  end

  def create_order(session, address)
    Order.create!(
      customer_email: session["customer_details"]["email"],
      total: session["amount_total"],
      address: address,
      fulfilled: false
    )
  end

  def process_line_items(session, order)
    full_session = Stripe::Checkout::Session.retrieve(id: session.id, expand: ['line_items'])
    line_items = full_session.line_items
    line_items["data"].each do |item|
      process_individual_item(item, order)
    end
  end

  def process_individual_item(item, order)
    product = Stripe::Product.retrieve(item["price"]["product"])
    product_id = product["metadata"]["product_id"].to_i
    OrderProduct.create!(
      order: order, 
      product_id: product_id, 
      quantity: item["quantity"], 
      size: product["metadata"]["size"]
    )
    Stock.find(product["metadata"]["product_stock_id"]).decrement!(:amount, item["quantity"])
  end
end
