require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:category) { create(:category) }

  before do
    create(:product, category: category, price: 200.00)
    create(:product, category: category, price: 450.00)
  end

  describe 'GET #show' do
    it 'assigns the requested category to @category' do
      get :show, params: { id: category.id }

      expect(assigns(:category)).to eq(category)
    end

    it 'assigns filtered products to @products based on max price' do
      get :show, params: { id: category.id, max: 300 }

      expect(assigns(:products)).to all(have_attributes(price: be <= 300.00))
    end

    it 'assigns filtered products to @products based on min price' do
      get :show, params: { id: category.id, min: 300 }

      expect(assigns(:products)).to all(have_attributes(price: be >= 300.00))
    end
  end
end
