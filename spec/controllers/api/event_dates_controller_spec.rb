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

  it 'returns validaton error message when event_date is expired' do
    expired_event_date =
      build(:event_date, service_id: 10, published_end_datetime:
      (DateTime.current - 2).utc.strftime('%Y-%m-%d %H:%M:%S'))
    expired_event_date.save(validate: false)

    get "api/event_dates/#{expired_event_date.event_date_id}"
    record = JSON.parse(response.body)

    expect(record['errors']['event_date'][0]['code']).to eq(1003)
    expect(record['errors']['event_date'][0]['message']).not_to be(nil)
  end

  it 'returns multiple validaton error messages' do
    event_date =
      build(:event_date, capacity: 50, reserved: 50,
                         service_id: 10, status_publish: 0,
                         published_date_key:
                         (Date.today - 2).to_s.delete('-'))
    event_date.save(validate: false)

    get "api/event_dates/#{event_date.event_date_id}"
    record = JSON.parse(response.body)

    expect(record['errors']['event_date'].count).to eq(2)
  end

  it 'shows the event details' do
    get "/api/event_dates/#{event_date.id}/event_details"

    expect(response.status).to eq 200
    event_date_response = JSON.parse(response.body)['event']['event_dates'][0]
    expect(event_date_response['id']).to eq(event_date.id)
  end
end
