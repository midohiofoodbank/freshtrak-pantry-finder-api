# frozen_string_literal: true

describe Api::EventsController, type: :controller do
  let(:event) { create(:event) }

  it 'shows the event' do
    get "/api/events/#{event.id}"

    expect(response.status).to eq 200
    event_response = JSON.parse(response.body)['event']
    expect(event_response['id']).to eq(event.id)
  end
end
