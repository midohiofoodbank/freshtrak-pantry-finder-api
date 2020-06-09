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
        'id' => event_date.id,
        'event_id' => event_date.event_id,
        'capacity' => event_date.capacity,
        'accept_walkin' => event_date.accept_walkin,
        'accept_reservations' => event_date.accept_reservations,
        'accept_interest' => event_date.accept_interest,
        'start_time' => '10 AM',
        'end_time' => '6 PM',
        'date' => '2020-06-10'
      }
    end
  end
end
