# frozen_string_literal: true

describe FoodbankSerializer do
  let(:foodbank_text) { create(:foodbank_text) }
  let(:default_twilio_phone_number) { '+16144129063' }

  it 'JSON single addr, display_url is Config.default_fb_display_url' do
    serializer =
      described_class.new(
        Foodbank.new(fb_name: 'local foodbank', address1: 'addr 1',
                     city: 'the town', state: 'OH', zip: '12345',
                     phone_public_help: '999-999-9999',
                     foodbank_texts: [foodbank_text])
      )

    exp_rslt = '{"id":null,"address":"addr 1","city":"the town","state":"OH",' \
    '"zip":"12345","phone":"999-999-9999",' \
    '"name":"local foodbank","nickname":"","logo":"",' \
    '"display_url":"https://www.feedingamerica.org/find-your-local-foodbank",' \
    '"fb_agency_locator_url":"",' \
    '"fb_url":"","fb_fano_url":null,"twilio_phone_number":"' \
    "#{default_twilio_phone_number}" \
    '","foodbank_texts":[{"id":' \
    "#{foodbank_text.id}" \
    ',"image_resource":"' \
    "#{foodbank_text.image_resource}" \
    '","text":"' \
    "#{foodbank_text.text}" \
    '","link_text":"' \
    "#{foodbank_text.link_text}" \
    '","link_href":"' \
    "#{foodbank_text.link_href}" \
    '","order":50}]}' \

    expect(serializer.to_json).to eql(exp_rslt)
  end

  it 'JSON combi addr, display_url is Config.default_fb_display_url' do
    serializer =
      described_class.new(
        Foodbank.new(fb_name: 'local foodbank', address1: 'addr 1',
                     address2: 'addr 2', city: 'the town', state: 'OH',
                     zip: '12345', phone_public_help: '999-999-9999',
                     foodbank_texts: [])
      )

    exp_rslt = '{"id":null,"address":"addr 1 addr 2","city":"the town",' \
                 '"state":"OH","zip":"12345","phone":"999-999-9999",' \
                 '"name":"local foodbank","nickname":"",' \
                 '"logo":"","display_url":"' \
                 "#{Config.default_fb_display_url}" \
                 '","fb_agency_locator_url":"",' \
                 '"fb_url":"","fb_fano_url":null,"twilio_phone_number":"' \
                 "#{default_twilio_phone_number}" \
                 '","foodbank_texts":[]}'
    expect(serializer.to_json).to eql(exp_rslt)
  end

  it 'JSON when display_url is fb_agency_locator_url' do
    serializer =
      described_class.new(
        Foodbank.new(fb_name: 'local foodbank', address1: 'addr 1',
                     address2: 'addr 2', city: 'the town',
                     state: 'OH', zip: '12345',
                     phone_public_help: '999-999-9999',
                     fb_agency_locator_url: 'fb_agency_locator_url',
                     foodbank_texts: [])
      )

    exp_rslt = '{"id":null,"address":"addr 1 addr 2","city":"the town",' \
                 '"state":"OH","zip":"12345","phone":"999-999-9999",' \
                 '"name":"local foodbank","nickname":"",' \
                 '"logo":"","display_url":"fb_agency_locator_url",' \
                 '"fb_agency_locator_url":"fb_agency_locator_url",'\
                 '"fb_url":"","fb_fano_url":null,"twilio_phone_number":"' \
                 "#{default_twilio_phone_number}" \
                 '","foodbank_texts":[]}'
    expect(serializer.to_json).to eql(exp_rslt)
  end

  it 'JSON when display_url is fb_url' do
    serializer =
      described_class.new(
        Foodbank.new(fb_name: 'local foodbank', address1: 'addr 1',
                     address2: 'addr 2', city: 'the town', state: 'OH',
                     zip: '12345', phone_public_help: '999-999-9999',
                     fb_url: 'fb_url', foodbank_texts: [])
      )

    exp_rslt = '{"id":null,"address":"addr 1 addr 2","city":"the town",' \
                 '"state":"OH","zip":"12345","phone":"999-999-9999",' \
                 '"name":"local foodbank","nickname":"","logo":"",' \
                 '"display_url":"fb_url","fb_agency_locator_url":"",' \
                 '"fb_url":"fb_url","fb_fano_url":null,' \
                 '"twilio_phone_number":"' \
                 "#{default_twilio_phone_number}" \
                 '","foodbank_texts":[]}'
    expect(serializer.to_json).to eql(exp_rslt)
  end

  it 'JSON when display_url is fb_fano_url' do
    serializer =
      described_class.new(
        Foodbank.new(fb_name: 'local foodbank', address1: 'addr 1',
                     address2: 'addr 2', city: 'the town', state: 'OH',
                     zip: '12345', phone_public_help: '999-999-9999',
                     fb_fano_url: 'fb_fano_url', foodbank_texts: [])
      )

    exp_rslt = '{"id":null,"address":"addr 1 addr 2","city":"the town",' \
                 '"state":"OH","zip":"12345","phone":"999-999-9999",' \
                 '"name":"local foodbank","nickname":"","logo":"",' \
                 '"display_url":"fb_fano_url",' \
                 '"fb_agency_locator_url":"","fb_url":"",' \
                 '"fb_fano_url":"fb_fano_url","twilio_phone_number":"' \
                 "#{default_twilio_phone_number}" \
                 '","foodbank_texts":[]}'
    expect(serializer.to_json).to eql(exp_rslt)
  end
end
