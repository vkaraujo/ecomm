require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:stocks) }
    it { is_expected.to have_many(:order_products) }
    it 'is expected to have many attached images' do
      expect(Product.new.images).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  describe 'scopes' do
    let(:category) { Category.create!(name: "Example Category") }
    let!(:product1) { Product.create!(price: 300, category: category) }
    let!(:product2) { Product.create!(price: 1000, category: category) }

    context 'max_price' do
      it 'returns products with price less than or equal to the specified max price' do
        expect(Product.max_price(500)).to include(product1)
        expect(Product.max_price(500)).not_to include(product2)
      end
    end

    context 'min_price' do
      it 'returns products with price greater than or equal to the specified min price' do
        expect(Product.min_price(500)).to include(product2)
        expect(Product.min_price(500)).not_to include(product1)
      end
    end
  end

  describe 'images variants' do
    let(:category) { Category.create!(name: "Example Category") }

    before do
      @product = Product.create!(category: category)
      @product.images.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_image.png')), filename: 'test_image.png', content_type: 'image/png')
    end

    it 'creates a thumb variant' do
      expect(@product.images.first.variant(:thumb).processed).not_to be_nil
    end

    it 'creates a medium variant' do
      expect(@product.images.first.variant(:medium).processed).not_to be_nil
    end
  end
end
