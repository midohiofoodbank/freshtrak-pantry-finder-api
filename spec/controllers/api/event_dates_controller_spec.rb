# frozen_string_literal: true

describe Api::EventDatesController, type: :controller do
  let(:capacity) { 37 }
  let(:event_date) { create(:event_date, capacity: capacity) }

  it 'shows the event date' do
    get "/api/event_dates/#{event_date.id}"

    expect(response.status).to eq 200
    event_date_response = JSON.parse(response.body)['event_date']
    expect(event_date_response['id']).to eq(event_date.id)
    expect(event_date_response['capacity']).to eq(capacity)
  end

  it 'returns error message when event_date is not found in database' do
    get 'api/event_dates/-404'
    event_date_response = JSON.parse(response.body)
    expect(event_date_response['status']).to eq(404)
    expect(event_date_response['error']).to eq('record_not_found')
    expect(event_date_response['message']).not_to be(nil)
  end

  it 'shows the event details' do
    get "/api/event_dates/#{event_date.id}/event_details"

    expect(response.status).to eq 200
    event_date_response = JSON.parse(response.body)['event']['event_dates'][0]
    expect(event_date_response['id']).to eq(event_date.id)
  end
end
