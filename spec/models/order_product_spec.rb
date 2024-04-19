require 'rails_helper'

RSpec.describe OrderProduct, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:product) }
    it { is_expected.to belong_to(:order) }
  end
end
