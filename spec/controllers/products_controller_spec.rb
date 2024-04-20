require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe 'GET #show' do
    let(:product) { create(:product) }

    it 'assigns the requested product to @product' do
      get :show, params: { id: product.id }

      expect(assigns(:product)).to eq(product)
    end

    it 'renders the show template' do
      get :show, params: { id: product.id }

      expect(response).to render_template(:show)
    end

    context 'when the product does not exist' do
      it 'raises a RecordNotFound error' do
        expect {
          get :show, params: { id: 9999 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
