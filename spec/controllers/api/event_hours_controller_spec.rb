# frozen_string_literal: true

describe Api::EventHoursController, type: :controller do
  let(:date) { Date.today.to_s }
  let(:event_date) { create(:event_date, date: date.delete('-')) }
  let!(:event_hour) { create(:event_hour, event_date: event_date) }
  let!(:event_slot) { create(:event_slot, event_hour: event_hour) }

  context 'with event dates by event_date_id' do
    before do
      get "api/event_dates/#{event_date.id}/event_hours"
    end

    it 'returns event hours of a specific event date' do
      json_response = JSON.parse(response.body)
      response = json_response['event_date']['event_hours']

      expect(response.count).to eq(1)
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
      response_body = event_hours.first['event_slots'].first
      response_body.should == expected_event_slots
    end
  end

  context 'with event dates and event slots by event_date_id' do
    before do
      get "api/event_dates/#{event_date.id}/event_hours"
    end

    it 'shows event dates and event slots' do
      response_body = JSON.parse(response.body)
      response_body.should == expected_response
    end
  end

  def expected_event_slots
    {
      'event_slot_id' => event_slot.event_slot_id,
      'capacity' => event_slot.capacity,
      'start_time' => format_time_key(event_slot.start_time_key.to_s),
      'end_time' => format_time_key(event_slot.end_time_key.to_s),
      'open_slots' => event_slot.capacity - event_slot.reserved
    }
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
        'start_time' => format_time_key(event_date.start_time_key.to_s),
        'end_time' => format_time_key(event_date.end_time_key.to_s),
        'date' => date,
        'event_hours' => [{
          'event_hour_id' => event_hour.event_hour_id,
          'capacity' => event_hour.capacity,
          'start_time' => format_time_key(event_hour.start_time_key.to_s),
          'end_time' => format_time_key(event_hour.end_time_key.to_s),
          'open_slots' => event_hour.capacity - event_hour.reserved,
          'event_slots' => [{
            'event_slot_id' => event_slot.event_slot_id,
            'capacity' => event_slot.capacity,
            'start_time' => format_time_key(event_slot.start_time_key.to_s),
            'end_time' => format_time_key(event_slot.end_time_key.to_s),
            'open_slots' => event_slot.capacity - event_slot.reserved
          }]
        }]
      }
    }
  end

  context 'with index action', type: :request do
    before do
      create(:event_hour, event_date: event_date)
      create(:event_hour, event_date: event_date)
    end

    it 'returns all event hours' do
      get 'api/event_hours'
      expect(JSON.parse(response.body)['event_hours'].size).to eq(3)
    end
  end

  context 'with show action', type: :request do
    before do
      get "api/event_hours/#{event_hour.event_hour_id}"
    end

    it 'returns one event hour' do
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  def format_time_key(time_key)
    time_key = "0#{time_key}" if time_key.length == 3
    minutes = time_key.last(2)
    if minutes == '00'
      Time.strptime(time_key, '%H%M').strftime('%l %p').lstrip
    else
      Time.strptime(time_key, '%H%M').strftime('%l:%M %p').lstrip
    end
  end
end
