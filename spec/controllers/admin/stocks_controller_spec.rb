require 'rails_helper'

RSpec.describe Admin::StocksController, type: :controller do
  let(:category) { create(:category) }
  let(:product) { create(:product, category: category) }
  let(:stock) { create(:stock, product: product) }
  let(:new_attributes) { { size: 'L', amount: 50 } }

  before do
    admin = create(:admin)
    sign_in admin
  end

  describe 'GET #index' do
    it 'lists all stocks for a given product' do
      stock
      get :index, params: { product_id: product.id }

      expect(assigns(:admin_stocks)).to include(stock)
    end
  end

  describe 'GET #show' do
    it 'shows the requested stock' do
      get :show, params: { id: stock.id, product_id: product.id }

      expect(assigns(:admin_stock)).to eq(stock)
    end
  end

  describe 'GET #new' do
    it 'assigns a new stock to @admin_stock' do
      get :new, params: { product_id: product.id }

      expect(assigns(:admin_stock)).to be_a_new(Stock)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Stock for the product' do
        expect {
          post :create, params: { product_id: product.id, stock: attributes_for(:stock) }
        }.to change(product.stocks, :count).by(1)
      end

      it 'redirects to the created stock' do
        post :create, params: { product_id: product.id, stock: attributes_for(:stock) }

        expect(response).to redirect_to(admin_product_stock_url(product, Stock.last))
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested stock' do
        put :update, params: { id: stock.id, product_id: product.id, stock: new_attributes }
        stock.reload

        expect(stock.size).to eq('L')
        expect(stock.amount).to eq(50)
      end

      it 'redirects to the stock' do
        put :update, params: { id: stock.id, product_id: product.id, stock: new_attributes }

        expect(response).to redirect_to(admin_product_stock_url(stock.product, stock))
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested stock' do
      stock
      expect {
        delete :destroy, params: { id: stock.id, product_id: product.id }
      }.to change(Stock, :count).by(-1)
    end

    it 'redirects to the stocks list' do
      delete :destroy, params: { id: stock.id, product_id: product.id }

      expect(response).to redirect_to(admin_product_stocks_url(product_id: product.id))
    end
  end
end
