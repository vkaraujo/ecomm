require 'rails_helper'

RSpec.describe StripeWebhookService do
  describe '#process' do
    let(:sig_header) { 't=12345,v1=abcdef,v0=xyz123' }
    let(:payload) { File.read(Rails.root.join('spec', 'fixtures', 'stripe_webhook_payload.json')) }

    before do
      allow(Rails.application.credentials).to receive(:dig).with(:stripe, :webhook_secret).and_return('fake_secret')
      allow(Stripe::Webhook).to receive(:construct_event).and_raise(Stripe::SignatureVerificationError.new("Signature verification failed", sig_header))
    end

    it 'returns a 400 error for invalid signatures' do
      service = StripeWebhookService.new(payload, sig_header)
      result = service.process
      expect(result[:status]).to eq(400)
      expect(result[:json]).to eq({error: "Invalid signature"})
    end
  end
end
