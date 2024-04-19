require 'rails_helper'

RSpec.describe Admin::CategoriesController, type: :controller do
  let(:category) { create(:category) }
  let(:invalid_attributes) { { name: '', description: '' } }
  let(:new_attributes) { { name: "Books", description: "All about books."} }

  before do
    admin = create(:admin)
    sign_in admin
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index, params: {}

      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: {id: category.to_param}

      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}

      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      get :edit, params: {id: category.to_param}

      expect(response).to be_successful
    end
  end

  describe 'POST' do
    context 'with valid params' do
      it 'creates a new cateogry' do
        expect {
          post :create, params: { category: attributes_for(:category) }
        }.to change(Category, :count).by(1)
      end

      it 'redirects to the created category' do
        post :create, params: { category: attributes_for(:category) }

        expect(response).to redirect_to(admin_category_url(Category.last))
      end
    end

    context 'with invalid params' do
      it 'does not create a new Category' do
        expect {
          post :create, params: { category: invalid_attributes }
        }.not_to change(Category, :count)
      end

      it 're-renders the new template' do
        post :create, params: { category: invalid_attributes }
        expect(response).to render_template(:new)
      end

      it 'returns an unprocessable entity status' do
        post :create, params: { category: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      it 'updates the requested category' do
        put :update, params: {id: category.to_param, category: new_attributes }
        category.reload

        expect(category.name).to eq("Books")
      end

      it 'redirects to the category' do
        put :update, params: {id: category.to_param, category: new_attributes }

        expect(response).to redirect_to(admin_category_url(category))
      end
    end

    context 'with invalid params' do
      it 'does not update the category' do
        original_name = category.name
        original_description = category.description
        put :update, params: { id: category.id, category: invalid_attributes }
        category.reload

        expect(category.name).to eq(original_name)
        expect(category.description).to eq(original_description)
      end

      it 're-renders the edit template' do
        put :update, params: { id: category.id, category: invalid_attributes }

        expect(response).to render_template(:edit)
      end

      it 'returns an unprocessable entity status' do
        put :update, params: { id: category.id, category: invalid_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested category' do
      category.reload

      expect {
        delete :destroy, params: {id: category.to_param}
      }.to change(Category, :count).by(-1)
    end

    it 'redirects to the categories list' do
      delete :destroy, params: {id: category.to_param}

      expect(response).to redirect_to(admin_categories_url)
    end
  end
end
