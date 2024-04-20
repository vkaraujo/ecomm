require 'rails_helper'

RSpec.describe StatsService do
  describe "#quick_stats" do
    let(:today) { Date.today }
    let(:yesterday) { Date.yesterday }
    let!(:orders_today) { create_list(:order, 3, created_at: today, total: 100) }
    let!(:orders_yesterday) { create_list(:order, 2, created_at: yesterday, total: 150) }

    subject(:stats_service) { described_class.new(today) }

    it "returns correct statistics for today's orders" do
      result = stats_service.quick_stats

      expect(result[:sales]).to eq(5)
      expect(result[:revenue]).to eq(600)
      expect(result[:avg_sale]).to eq(120)
    end
  end

  describe "#revenue_by_day" do
    let(:today) { Date.parse("Sunday") }
    let(:six_days_ago) { today - 6.days }
    let!(:order_from_last_week) { create(:order, created_at: six_days_ago, total: 200) }

    subject(:stats_service) { described_class.new(today) }

    it "returns revenue grouped by day of the week with missing days filled" do
      result = stats_service.revenue_by_day

      expect(result).to include(["Sunday", 0], ["Monday", 200], ["Saturday", 0])
      expect(result.size).to eq(7)
    end
  end
end
