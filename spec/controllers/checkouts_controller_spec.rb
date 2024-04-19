require 'rails_helper'

RSpec.describe CheckoutsController, type: :controller do
  describe 'POST #create' do
    let(:cart_params) { { cart: { id: '1', size: 'M', quantity: 2, price: 2500, name: 'T-Shirt' } } }

    before do
      allow_any_instance_of(StripeCheckoutService).to receive(:create_session).and_return(expected_response)
    end

    context 'when the checkout process succeeds' do
      let(:expected_response) { { url: 'http://example.com/success' } }

      it 'returns a success response with the session URL' do
        post :create, params: cart_params

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["url"]).to eq('http://example.com/success')
      end
    end

    context 'when the checkout process fails' do
      let(:expected_response) { { error: "Invalid request", status: 422 } }

      it 'returns an error response with the appropriate status' do
        post :create, params: cart_params

        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["error"]).to eq('Invalid request')
      end
    end
  end

  describe 'GET #success' do
    it 'renders the success template' do
      get :success

      expect(response).to render_template(:success)
    end
  end

  describe 'GET #cancel' do
    it 'renders the cancel template' do
      get :cancel

      expect(response).to render_template(:cancel)
    end
  end
end
