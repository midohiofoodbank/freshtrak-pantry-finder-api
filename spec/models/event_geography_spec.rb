# frozen_string_literal: true

describe EventGeography, type: :model do
  let(:event_geography) { create(:event_geography) }

  it 'has event_zip_codes' do
    event_zip_codes =
      5.times.map { create(:event_zip_code, event_geography: event_geography) }

    expect(event_geography.event_zip_codes.pluck(:id))
      .to eq(event_zip_codes.pluck(:id))
  end

  context 'with scopes' do
    it 'defaults to active geographies' do
      active = create(:event_geography, status_id: 1)
      create(:event_geography, status_id: 0)
      expected_id = active.id
      expect(described_class.all.pluck(:id)).to eq([expected_id])
    end
  end
end
