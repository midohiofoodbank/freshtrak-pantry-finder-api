# frozen_string_literal: true

describe FoodbankText, type: :model do
  let(:foodbank_text) { create(:foodbank_text) }

  it 'association for fb text' do
    expect(foodbank_text.foodbank).to be_an_instance_of(Foodbank)
  end
end
