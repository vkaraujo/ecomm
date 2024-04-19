class StatsService
  DAYS_OF_THE_WEEK = %w[Monday Tuesday Wednesday Thursday Friday Saturday Sunday].freeze

  def initialize(date = Date.today)
    @date = date
  end

  def quick_stats
    orders_today = Order.where(created_at: @date.midnight..@date)
    {
      sales: orders_today.count,
      revenue: orders_today.sum(:total)&.round,
      avg_sale: orders_today.average(:total)&.round,
      per_sale: OrderProduct.joins(:order).where(orders: { created_at: @date.midnight..@date })&.average(:quantity)
    }
  end

  def revenue_by_day
    orders_by_day = Order.where('created_at > ?', @date - 7.days).order(:created_at).group_by { |order| order.created_at.to_date }
    revenue_by_day = orders_by_day.map { |day, orders| [day.strftime('%A'), orders.sum(&:total)] }
    fill_missing_days(revenue_by_day)
  end

  private

  def fill_missing_days(revenue_by_day)
    full_week = DAYS_OF_THE_WEEK.cycle(2).to_a
    start_index = full_week.index(@date.strftime('%A'))

    (start_index...start_index + 7).map do |i|
      day = full_week[i]
      [day, revenue_by_day.to_h.fetch(day, 0)]
    end
  end
end
