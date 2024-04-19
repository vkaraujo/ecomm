require 'rails_helper'

RSpec.describe AdminController, type: :controller do
  let(:admin) { create(:admin) }

  before do
    allow(controller).to receive(:authenticate_admin!).and_return(true)
    sign_in admin
  end

  describe 'GET #index' do
    let(:stats_service) { instance_double("StatsService") }

    before do
      allow(StatsService).to receive(:new).and_return(stats_service)
      allow(stats_service).to receive(:quick_stats).and_return({ total_orders: 10, total_revenue: 5000 })
      allow(stats_service).to receive(:revenue_by_day).and_return(AdminController::DAYS_OF_THE_WEEK.zip([100] * 7).to_h)
    end

    it 'assigns @orders' do
      order = create(:order, fulfilled: false)
      get :index
      expect(assigns(:orders)).to match_array([order])
    end

    it 'calls StatsService for quick stats' do
      get :index
      expect(stats_service).to have_received(:quick_stats)
      expect(assigns(:quick_stats)).to eq({ total_orders: 10, total_revenue: 5000 })
    end

    it 'calls StatsService for revenue by day' do
      get :index
      expect(stats_service).to have_received(:revenue_by_day)
      expect(assigns(:revenue_by_day)).to eq(AdminController::DAYS_OF_THE_WEEK.zip([100] * 7).to_h)
    end
  end
end
