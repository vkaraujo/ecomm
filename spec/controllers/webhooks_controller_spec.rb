require 'rails_helper'

RSpec.describe WebhooksController, type: :controller do
  describe 'POST #stripe' do
    let(:valid_signature) { 'valid_signature' }
    let(:payload) { { some: 'data' }.to_json }

    before do
      request.headers['HTTP_STRIPE_SIGNATURE'] = valid_signature
      allow(StripeWebhookService).to receive(:new).and_return(stripe_service)
      allow(stripe_service).to receive(:process).and_return(service_response)
    end

    let(:stripe_service) { instance_double(StripeWebhookService) }

    context 'when the webhook processing is successful' do
      let(:service_response) { { status: 200, json: { message: 'success' } } }

      it 'returns success' do
        post :stripe, body: payload

        expect(response).to have_http_status(:ok)
        expect(response.body).to eq({ message: 'success' }.to_json)
      end
    end

    context 'when the webhook processing fails' do
      let(:service_response) { { status: 400, json: { error: 'Invalid signature' } } }

      it 'returns an error' do
        post :stripe, body: payload

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq({ error: 'Invalid signature' }.to_json)
      end
    end
  end
end
