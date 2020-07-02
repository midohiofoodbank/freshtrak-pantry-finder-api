# frozen_string_literal: true

describe Form, type: :model do
  let(:form) { create(:form) }

  it 'belongs to an event' do
    expect(form.event).to be_an_instance_of(Event)
  end

  context 'with scopes' do
    it 'defaults to active forms' do
      active = create(:form, status_id: 1)
      create(:form, status_id: 0)
      expected_id = active.id
      expect(described_class.all.pluck(:id)).to eq([expected_id])
    end

    it 'does not include results outside of date range' do
      within_range = create(:form, effective_start: Date.today.to_s)
      create(:form, effective_start: (Date.today + 1).to_s)
      expected_id = within_range.id
      expect(described_class.all.pluck(:id)).to eq([expected_id])
    end
  end
end
