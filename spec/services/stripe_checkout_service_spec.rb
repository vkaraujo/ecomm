require 'rails_helper'

RSpec.describe StripeCheckoutService do
  describe '#create_session' do
    let(:product) { create(:product) }
    let!(:stock) { create(:stock, product: product, size: 'M', amount: 10) }
    let(:cart) { [{ 'id' => product.id.to_s, 'size' => 'M', 'quantity' => 3, 'price' => 1500, 'name' => product.name }] }

    before do
      Stripe.api_key = 'sk_test_4eC39HqLyjWDarjtT1zdp7dc'
      allow(Stripe::Checkout::Session).to receive(:create).and_return(OpenStruct.new(url: 'http://example.com/payment'))
    end

    it 'creates a checkout session successfully' do
      service = StripeCheckoutService.new(cart)
      result = service.create_session
      expect(result).to have_key(:url)
      expect(result[:url]).to eq('http://example.com/payment')
    end

    context 'when there is insufficient stock' do
      let(:cart) { [{ 'id' => product.id.to_s, 'size' => 'M', 'quantity' => 20, 'price' => 1500, 'name' => product.name }] }

      it 'returns an error for insufficient stock' do
        service = StripeCheckoutService.new(cart)
        result = service.create_session

        expect(result).to have_key(:error)
        expect(result[:error]).to include("Stock issues")
        expect(result[:status]).to eq(400)
      end
    end
  end
end
