# frozen_string_literal: true

describe EventDateSerializer do
  context 'with attributes' do
    let(:capacity) { 37 }
    let(:event_date) { create(:event_date, capacity: capacity) }

    it 'includes event date attributes' do
      serialized_object = JSON.parse(described_class.new(event_date).to_json)
      serialized_object.should == expected_attributes
    end

    def expected_attributes
      {
        'id' => 61, 'event_id' => 87, 'capacity' => 37,
        'accept_walkin' => 1, 'accept_reservations' => 1,
        'accept_interest' => 1, 'start_time' => '10 AM',
        'end_time' => '6 PM', 'date' => '2020-06-10'
      }
    end
  end
end
