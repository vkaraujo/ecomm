class Product < ApplicationRecord
  scope :max_price, ->(price) { where('price <= ?', price) if price.present? }
  scope :min_price, ->(price) { where('price >= ?', price) if price.present? }

  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [50, 50]
    attachable.variant :medium, resize_to_limit: [250, 250]
  end

  belongs_to :category
  has_many :stocks
  has_many :order_products
end
