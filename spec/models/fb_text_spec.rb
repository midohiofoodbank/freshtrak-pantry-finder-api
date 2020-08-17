# frozen_string_literal: true

describe FbText, type: :model do
  let(:fb_text) { create(:fb_text) }

  it 'association for fb text' do
    expect(fb_text.foodbank).to be_an_instance_of(Foodbank)
  end
end
