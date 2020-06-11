# frozen_string_literal: true

describe Api::EventHoursController, type: :controller do
  let(:date) { Date.today.to_s }
  let(:event_date) { create(:event_date, date: date.delete('-')) }
  let!(:event_hour) { create(:event_hour, event_date: event_date) }

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
      create(:event_slot, event_hour: event_hour)
      get "api/event_dates/#{event_date.id}/event_hours"
    end

    it 'shows event dates and event slots' do
      response_body = JSON.parse(response.body)
      response_body.should == expected_response
    end
  end

  def expected_event_slots
    {
      'event_slot_id' => 1,
      'start_time' => '10 AM',
      'end_time' => '11 AM',
      'open_slots' => 5
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
        'start_time' => '10 AM',
        'end_time' => '6 PM',
        'date' => date,
        'event_hours' => [{
          'event_hour_id' => event_hour.event_hour_id,
          'start_time' => '10 AM',
          'end_time' => '11 AM',
          'open_slots' => event_hour.open_slots,
          'event_slots' => [{
            'event_slot_id' => 2,
            'start_time' => '10 AM',
            'end_time' => '11 AM',
            'open_slots' => 5
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
end
