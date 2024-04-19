require 'rails_helper'

RSpec.describe Admin::ProductsController, type: :controller do
  let(:invalid_attributes) {
    { name: '', description: '', price: nil, category_id: nil }
  }

  let(:category) { create(:category)}
  let(:product) { create(:product, category: category) }

  before do
    admin = create(:admin)
    sign_in admin
  end

  describe 'GET #index' do
    context "with search query" do
      it 'filters products by name' do
        product = create(:product, name: 'UniqueName', category: category)
        get :index, params: { query: 'UniqueName' }
        expect(assigns(:admin_products)).to include(product)
      end
    end

    context "without search query" do
      it 'lists all products' do
        product
        get :index
        expect(assigns(:admin_products)).to include(product)
      end
    end
  end

  describe 'GET #show' do
    it 'assigns the requested product to @admin_product' do
      get :show, params: { id: product.id }
      expect(assigns(:admin_product)).to eq(product)
    end
  end

  describe 'GET #new' do
    it 'assigns a new Product to @admin_product' do
      get :new
      expect(assigns(:admin_product)).to be_a_new(Product)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested product for edit' do
      get :edit, params: { id: product.id }
      expect(assigns(:admin_product)).to eq(product)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new Product' do
        expect {
          post :create, params: { product: attributes_for(:product, category_id: category.id) }
        }.to change(Product, :count).by(1)
      end

      it 'redirects to the created product' do
        post :create, params: { product: attributes_for(:product, category_id: category.id) }

        expect(response).to redirect_to(admin_product_url(Product.last))
      end
    end

    context 'with invalid params' do
      it 're-renders the new template' do
        post :create, params: { product: invalid_attributes }

        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PUT #update' do
    let(:new_attributes) {
      { name: 'Updated Product', description: 'Updated Description' }
    }

    context 'with valid params' do
      it 'updates the requested product' do
        put :update, params: { id: product.id, product: new_attributes }
        product.reload

        expect(product.name).to eq('Updated Product')
      end

      it 'redirects to the product' do
        put :update, params: { id: product.id, product: new_attributes }

        expect(response).to redirect_to(admin_product_url(product))
      end
    end

    context 'with invalid params' do
      it 're-renders the edit template' do
        put :update, params: { id: product.id, product: invalid_attributes }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested product' do
      product.reload
      expect {
        delete :destroy, params: { id: product.id }

      }.to change(Product, :count).by(-1)
    end

    it 'redirects to the products list' do
      delete :destroy, params: { id: product.id }

      expect(response).to redirect_to(admin_products_url)
    end
  end
end
