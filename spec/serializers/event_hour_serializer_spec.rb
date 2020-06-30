# frozen_string_literal: true

describe EventHourSerializer do
  context 'with attributes' do
    let(:capacity) { 37 }
    let(:event_hour) { create(:event_hour, capacity: capacity) }

    it 'includes event date attributes' do
      serialized_object = JSON.parse(described_class.new(event_hour).to_json)
      serialized_object.should == expected_attributes
    end

    def expected_attributes
      {
        'event_hour_id' => event_hour.event_hour_id,
        'capacity' => 37,
        'start_time' => '10 AM',
        'end_time' => '11 AM',
        'open_slots' => event_hour.open_slots
      }
    end
  end
end
