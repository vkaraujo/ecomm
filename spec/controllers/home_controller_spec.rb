require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    before do
      create_list(:category, 5)
    end

    it 'assigns the first NUM_OF_CATEGORIES categories to @main_categories' do
      get :index

      expect(assigns(:main_categories).size).to eq(HomeController::NUM_OF_CATEGORIES)
      expect(assigns(:main_categories)).to match_array(Category.take(HomeController::NUM_OF_CATEGORIES))
    end

    it 'renders the index template' do
      get :index

      expect(response).to render_template(:index)
    end
  end
end
