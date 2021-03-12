# frozen_string_literal: true

describe EventDateSerializer do
  context 'with attributes' do
    let(:date) { Date.today.to_s }
    let(:event_date) { create(:event_date, date: date.delete('-')) }

    it 'includes event date attributes' do
      serialized_object = JSON.parse(described_class.new(event_date).to_json)
      serialized_object.should == expected_attributes
    end

    def expected_attributes
      {
        'id' => event_date.id,
        'event_id' => event_date.event_id,
        'capacity' => event_date.capacity,
        'reserved' => event_date.reserved,
        'accept_walkin' => event_date.accept_walkin,
        'accept_reservations' => event_date.accept_reservations,
        'accept_interest' => event_date.accept_interest,
        'start_time' => '10 AM',
        'end_time' => '6 PM',
        'date' => date
      }
    end
  end
end
