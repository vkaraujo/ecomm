class Category < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [50, 50]
    attachable.variant :large, resize_and_pad: [512, 512]
  end

  has_many :products
end
