# frozen_string_literal: true

describe Api::AgenciesController, type: :controller do
  let(:zip_code) { create(:zip_code) }
  let(:date) { (Date.today + 5).to_s }
  let(:agency) { create(:agency) }
  let(:event) { create(:event, agency: agency) }
  let!(:event_zip_code) do
    create(:event_zip_code, event: event, zip_code: zip_code.zip_code)
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
    request_params = request.params.query_params
    expect(response.status).to eq 200
    response_body = JSON.parse(response.body).deep_symbolize_keys
    expect(response_body).to eq(expected_response(request_params))
  end

  it 'is indexable by event_date' do
    get '/api/agencies', event_date: date
    request_params = request.params.query_params
    expect(response.status).to eq 200
    response_body = JSON.parse(response.body).deep_symbolize_keys
    expect(response_body).to eq(expected_response(request_params))
  end

  it 'is indexable by zip_code and event_date' do
    get '/api/agencies', zip_code: event_zip_code.zip_code, event_date: date
    request_params = request.params.query_params
    expect(response.status).to eq 200
    response_body = JSON.parse(response.body).deep_symbolize_keys
    expect(response_body).to eq(expected_response(request_params))
  end

  def expected_response(rq_prms)
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
              estimated_distance: event.estimated_distance(
                loc_lat(rq_prms, event_zip_code.zip_code),
                loc_long(rq_prms, event_zip_code.zip_code)
              ),
              event_dates: [
                {
                  id: event_date.id,
                  event_id: event.id,
                  start_time: '09:30 AM',
                  end_time: '10:00 PM',
                  date: date
                }
              ]
            }
          ]
        }
      ]
    }
  end

  # Supply lat/long from the zip code to call the model distance
  # method.
  def loc_lat(rq_prms, zip_code)
    rq_prms.to_s.include?('zip_code') ? Geo.zip_lat(zip_code) : nil
  end

  def loc_long(rq_prms, zip_code)
    rq_prms.to_s.include?('zip_code') ? Geo.zip_long(zip_code) : nil
  end
end
