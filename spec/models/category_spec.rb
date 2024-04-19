require 'rails_helper'

RSpec.describe Category, type: :model do
  let(:category) { create(:category) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
  end

  it 'is expected to have one attached image' do
    is_expected.to respond_to(:image)
  end

  describe 'associations' do
    it { is_expected.to have_many(:products) }
  end

  describe 'image variants' do
    before do
      @category = category
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
