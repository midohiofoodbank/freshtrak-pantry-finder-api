# frozen_string_literal: true

describe Api::AgenciesController, type: :controller do
  let(:zip_code) { create(:zip_code) }
  let(:date) { (Date.today + 5).to_s }
  let(:agency) { create(:agency) }
  let(:event) { create(:event, agency: agency) }
  let(:event_geography) { create(:event_geography, event_id: event.event_id) }
  let!(:event_zip_code) do
    create(:event_zip_code, event: event, zip_code: zip_code.zip_code,
                            event_geography: event_geography)
  end
  let!(:event_date) do
    create(:event_date, event: event, date: date.delete('-'),
                        start_time_key: 930, end_time_key: 2200)
  end

  before do
    other_zip = create(:zip_code)
    other_date = (Date.today + 2).to_s.delete('-')
    other_foodbank = create(:foodbank, county_ids: other_zip.county.id)
    other_agency = create(:agency, foodbank: other_foodbank)
    other_event = create(:event, agency: other_agency)
    create(:event_date, event: other_event, date: other_date)
  end

  it 'responds with no agencies without filter params' do
    get '/api/agencies'
    expect(response.status).to eq 200
    response_body = JSON.parse(response.body)
    expect(response_body['agencies']).to be_empty
  end

  it 'is indexable by zip_code' do
    get '/api/agencies', zip_code: event_zip_code.zip_code
    expect(response.status).to eq 200
    response_body = JSON.parse(response.body).deep_symbolize_keys
    expect(response_body).to eq(expected_response(zip_code.lat, zip_code.long))
  end

  it 'is indexable by event_date' do
    get '/api/agencies', event_date: date
    expect(response.status).to eq 200
    response_body = JSON.parse(response.body).deep_symbolize_keys
    expect(response_body).to eq(expected_response)
  end

  it 'is indexable by zip_code and event_date' do
    get '/api/agencies', zip_code: event_zip_code.zip_code, event_date: date
    expect(response.status).to eq 200
    response_body = JSON.parse(response.body).deep_symbolize_keys
    expect(response_body).to eq(expected_response(zip_code.lat, zip_code.long))
  end

  it 'is indexable by zip_code and includes lat & long params' do
    get '/api/agencies', zip_code: event_zip_code.zip_code, lat: event.lat.to_s,
                         long: event.long.to_s
    expect(response.status).to eq 200
    response_body = JSON.parse(response.body).deep_symbolize_keys
    expect(response_body).to eq(expected_response(event.lat, event.long))
  end

  it 'is indexable by event_date and includes lat & long params' do
    get '/api/agencies', event_date: date, lat: event.lat.to_s,
                         long: event.long.to_s
    expect(response.status).to eq 200
    response_body = JSON.parse(response.body).deep_symbolize_keys
    expect(response_body).to eq(expected_response(event.lat, event.long))
  end

  it 'is indexable by event_date and zip_code and includes lat & long params' do
    get '/api/agencies', zip_code: event_zip_code.zip_code, event_date: date,
                         lat: event.lat.to_s, long: event.long.to_s
    expect(response.status).to eq 200
    response_body = JSON.parse(response.body).deep_symbolize_keys
    expect(response_body).to eq(expected_response(event.lat, event.long))
  end

  it 'is indexable by zip_code and includes non-numeric lat & long params' do
    get '/api/agencies', zip_code: event_zip_code.zip_code, lat: 'dog',
                         long: 'cat'
    expect(response.status).to eq 200
    response_body = JSON.parse(response.body).deep_symbolize_keys
    expect(response_body).to eq(expected_response(zip_code.lat, zip_code.long))
  end

  it 'is indexable by event_date and includes invalid lat & long params' do
    get '/api/agencies', event_date: date, lat: '100.1', long: '-190.9'
    expect(response.status).to eq 200
    response_body = JSON.parse(response.body).deep_symbolize_keys
    expect(response_body).to eq(expected_response)
  end

  def expected_response(lat = nil, long = nil)
    {
      agencies: [
        {
          id: agency.id,
          address: "#{agency.address1} #{agency.address2}",
          city: agency.city,
          state: agency.state,
          zip: agency.zip,
          phone: agency.phone,
          name: agency.loc_name,
          nickname: agency.loc_nickname,
          estimated_distance: Geo.distance_between(
            OpenStruct.new(lat: lat, long: long), agency
          ),
          events: [
            {
              id: event.id,
              address: "#{event.address1} #{event.address2}",
              city: event.city,
              state: event.state,
              zip: event.zip,
              latitude: event.pt_latitude.to_f.to_s,
              longitude: event.pt_longitude.to_f.to_s,
              agency_id: event.loc_id,
              name: event.event_name,
              service: event.service_description,
              estimated_distance: Geo.distance_between(
                OpenStruct.new(lat: lat, long: long), event
              ),
              exception_note: 'local restrictions apply',
              event_dates: [
                {
                  id: event_date.id,
                  event_id: event.id,
                  capacity: 25,
                  start_time: '9:30 AM',
                  end_time: '10 PM',
                  date: date
                }
              ]
            }
          ]
        }
      ]
    }
  end
end
