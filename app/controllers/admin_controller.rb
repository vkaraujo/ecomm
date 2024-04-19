class AdminController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  DAYS_OF_THE_WEEK = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].freeze

  def index
    @orders = Order.where(fulfilled: false).order(created_at: :desc).take(5)
    stats_service = StatsService.new
    @quick_stats = stats_service.quick_stats
    @revenue_by_day = stats_service.revenue_by_day
  end
end
