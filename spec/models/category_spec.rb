require 'rails_helper'

RSpec.describe Category, type: :model do
  it 'is expected to have one attached image' do
    is_expected.to respond_to(:image)
  end

  describe 'associations' do
    it { is_expected.to have_many(:products) }
  end

  describe 'image variants' do
    before do
      @category = Category.create!
      @category.image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'test_image.png')), filename: 'test_image.png', content_type: 'image/png')
    end

    it 'creates a thumb variant' do
      expect(@category.image.variant(:thumb).processed).not_to be_nil
    end

    it 'creates a large variant' do
      expect(@category.image.variant(:large).processed).not_to be_nil
    end
  end
end
