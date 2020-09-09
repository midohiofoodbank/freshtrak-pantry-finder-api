# frozen_string_literal: true

describe Api::EventsController, type: :controller do
  let(:event) { create(:event) }

  it 'shows the event' do
    get "/api/events/#{event.id}"

    expect(response.status).to eq 200
    event_response = JSON.parse(response.body)['event']
    expect(event_response['id']).to eq(event.id)
  end

  it 'returns error message when event_date is not found in database' do
    get 'api/events/-404'
    event_response = JSON.parse(response.body)
    expect(event_response['status']).to eq(404)
    expect(event_response['error']).to eq('record_not_found')
    expect(event_response['message']).not_to be(nil)
  end
end
