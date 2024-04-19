require 'rails_helper'

RSpec.describe Admin::OrdersController, type: :controller do
  let(:invalid_attributes) {
    { customer_email: '', fulfilled: nil, total: nil, address: '' }
  }

  before do
    admin = create(:admin)
    sign_in admin
  end

  describe 'GET #index' do
    it 'populates an array of unfulfilled orders' do
      order = create(:order, fulfilled: false)
      get :index
      expect(assigns(:not_fulfilled_orders)).to eq([order])
    end

    it 'populates an array of fulfilled orders' do
      order = create(:order, fulfilled: true)
      get :index
      expect(assigns(:fulfilled_orders)).to eq([order])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested order to @admin_order' do
      order = create(:order)
      get :show, params: { id: order.id }
      expect(assigns(:admin_order)).to eq(order)
    end
  end

  describe 'GET #new' do
    it 'assigns a new Order to @admin_order' do
      get :new
      expect(assigns(:admin_order)).to be_a_new(Order)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Order' do
        expect {
          post :create, params: { order: attributes_for(:order) }
        }.to change(Order, :count).by(1)
      end

      it 'redirects to the created order' do
        post :create, params: { order: attributes_for(:order) }
        expect(response).to redirect_to(admin_order_url(Order.last))
      end
    end
  end

  describe 'PUT #update' do
    let(:order) { create(:order) }

    context 'with valid params' do
      let(:new_attributes) {
        { customer_email: 'updated@example.com', fulfilled: true }
      }

      it 'updates the requested order' do
        put :update, params: { id: order.id, order: new_attributes }
        order.reload
        expect(order.customer_email).to eq('updated@example.com')
        expect(order.fulfilled).to be true
      end

      it 'redirects to the order' do
        put :update, params: { id: order.id, order: new_attributes }
        expect(response).to redirect_to(admin_order_url(order))
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:order) { create(:order) }

    it 'destroys the requested order' do
      expect {
        delete :destroy, params: { id: order.id }
      }.to change(Order, :count).by(-1)
    end

    it 'redirects to the orders list' do
      delete :destroy, params: { id: order.id }
      expect(response).to redirect_to(admin_orders_url)
    end
  end
end
