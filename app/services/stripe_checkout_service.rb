class StripeCheckoutService
  def initialize(cart)
    @cart = cart
    Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
  end

  def create_session
    line_items = prepare_line_items
    return { error: "Stock issues", status: 400 } if line_items.is_a?(Hash) && line_items[:error]

    session = Stripe::Checkout::Session.create(
      mode: "payment",
      line_items: line_items,
      success_url: "http://localhost:3000/success",
      cancel_url: "http://localhost:3000/cancel",
      shipping_address_collection: { allowed_countries: ['US', 'CA'] }
    )
    { url: session.url }
  end

  private

  def prepare_line_items
    @cart.map do |item|
      product = Product.find(item["id"])
      product_stock = product.stocks.find { |ps| ps.size == item["size"] }

      if product_stock.amount < item["quantity"].to_i
        return { error: "Not enough stock for #{product.name} in size #{item["size"]}. Only #{product_stock.amount} left." }
      end

      {
        quantity: item["quantity"].to_i,
        price_data: { 
          product_data: {
            name: item["name"],
            metadata: { product_id: product.id, size: item["size"], product_stock_id: product_stock.id }
          },
          currency: "usd",
          unit_amount: item["price"].to_i
        }
      }
    end
  end
end
