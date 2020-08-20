# frozen_string_literal: true

describe FoodbankText, type: :model do
  let(:foodbank_text) { create(:foodbank_text) }

  it 'association for foodbank text' do
    expect(foodbank_text.foodbank).to be_an_instance_of(Foodbank)
  end

  context 'with scopes' do
    it 'defaults to active foodbank_texts' do
      active = create(:foodbank_text, status_id: 1)
      create(:foodbank_text, status_id: 0)
      expected_id = active.id
      expect(described_class.all.pluck(:id)).to eq([expected_id])
    end
  end
end
