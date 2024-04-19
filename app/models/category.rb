class Category < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [50, 50]
    attachable.variant :large, resize_and_pad: [512, 512]
  end

  has_many :products
end
