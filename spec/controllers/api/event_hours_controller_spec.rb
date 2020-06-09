# frozen_string_literal: true

describe Api::EventHoursController, type: :controller do
  let(:capacity) { 10 }
  let(:event_date) { create(:event_date, capacity: capacity) }
  let!(:event_hour) { create(:event_hour, event_date: event_date) }

  context 'with event dates by event_date_id' do
    before do
      get "api/event_dates/#{event_date.id}/event_hours"
    end

    it 'returns event hours of a specific event date' do
      json_response = JSON.parse(response.body)
      response = json_response['event_date']['event_hours'].first

      expect(response['event_hour_id']).to eq(event_hour.event_hour_id)
      expect(response['start_time_key']).to eq(event_hour.start_time_key)
      expect(response['end_time_key']).to eq(event_hour.end_time_key)
      expect(response['open_slots']).to eq(event_hour.open_slots)
    end

    it 'responds with no event slots without event slots data' do
      expect(response.status).to eq 200
      response_body = JSON.parse(response.body)
      expect(response_body['event_slots']).to eq(nil)
    end
  end

  context 'with event slots by event_date_id' do
    before do
      create(:event_slot, event_hour: event_hour)
      get "api/event_dates/#{event_date.id}/event_hours"
    end

    it 'shows event slots' do
      response_body = JSON.parse(response.body)
      event_hours = response_body['event_date']['event_hours']
      event_slots = event_hours.first['event_slots'].first
      expect(event_slots).to eq({ 'event_slot_id' => 1,
                                  'start_time_key' => 1000,
                                  'end_time_key' => 1100,
                                  'open_slots' => 5 })
    end
  end

  context 'with event dates and event slots by event_date_id' do
    before do
      create(:event_slot, event_hour: event_hour)
      get "api/event_dates/#{event_date.id}/event_hours"
    end

    it 'shows event dates and event slots' do
      response_body = JSON.parse(response.body)
      response_body.should == expected_response
    end
  end

  def expected_response
    {
      'event_date' =>
      {
        'id' => event_date.id,
        'event_id' => event_date.event_id,
        'capacity' => event_date.capacity,
        'accept_walkin' => event_date.accept_walkin,
        'accept_reservations' => event_date.accept_reservations,
        'accept_interest' => event_date.accept_interest,
        'start_time' => '10 AM',
        'end_time' => '6 PM',
        'date' => '2020-06-10',
        'event_hours' => [{
          'event_hour_id' => event_hour.event_hour_id,
          'start_time_key' => event_hour.start_time_key,
          'end_time_key' => event_hour.end_time_key,
          'open_slots' => event_hour.open_slots, 'event_slots' => [{
            'event_slot_id' => 2, 'start_time_key' => 1000,
            'end_time_key' => 1100,
            'open_slots' => 5
          }]
        }]
      }
    }
  end
end
