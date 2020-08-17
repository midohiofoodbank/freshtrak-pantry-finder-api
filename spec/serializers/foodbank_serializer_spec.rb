# frozen_string_literal: true

describe FoodbankSerializer do
  let(:fb_text) { create(:fb_text) }

  it 'JSON single addr, display_url is Config.default_fb_display_url' do
    serializer =
      described_class.new(
        Foodbank.new(fb_name: 'local foodbank', address1: 'addr 1',
                     city: 'the town', state: 'OH', zip: '12345',
                     phone_public_help: '999-999-9999', fb_texts: [fb_text])
      )

    exp_rslt = '{"id":null,"address":"addr 1","city":"the town","state":"OH",' \
    '"zip":"12345","phone":"999-999-9999",' \
    '"name":"local foodbank","nickname":"","logo":"",' \
    '"display_url":"https://www.feedingamerica.org/find-your-local-foodbank",' \
    '"fb_agency_locator_url":"",' \
    '"fb_url":"","fb_fano_url":null,"fb_texts":[{"id":' \
    "#{fb_text.id}" \
    ',"image_resource":"The location of an externally hosted",' \
    '"text":"The piece of text the foodbank wants to show on FreshTrak",' \
    '"link_text":"The inner content of \u003ca\u003e\u003c/a\u003e tag",' \
    '"link_href":"The href property of an \u003ca\u003e\u003c/a\u003e tag",' \
    '"order":50}]}'
    expect(serializer.to_json).to eql(exp_rslt)
  end

  it 'JSON combi addr, display_url is Config.default_fb_display_url' do
    serializer =
      described_class.new(
        Foodbank.new(fb_name: 'local foodbank', address1: 'addr 1',
                     address2: 'addr 2', city: 'the town', state: 'OH',
                     zip: '12345', phone_public_help: '999-999-9999',
                     fb_texts: [])
      )

    exp_rslt = '{"id":null,"address":"addr 1 addr 2","city":"the town",' \
                 '"state":"OH","zip":"12345","phone":"999-999-9999",' \
                 '"name":"local foodbank","nickname":"",' \
                 '"logo":"","display_url":"' \
                 "#{Config.default_fb_display_url}" \
                 '","fb_agency_locator_url":"",' \
                 '"fb_url":"","fb_fano_url":null,"fb_texts":[]}'
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
                     fb_texts: [])
      )

    exp_rslt = '{"id":null,"address":"addr 1 addr 2","city":"the town",' \
                 '"state":"OH","zip":"12345","phone":"999-999-9999",' \
                 '"name":"local foodbank","nickname":"",' \
                 '"logo":"","display_url":"fb_agency_locator_url",' \
                 '"fb_agency_locator_url":"fb_agency_locator_url",'\
                 '"fb_url":"","fb_fano_url":null,"fb_texts":[]}'
    expect(serializer.to_json).to eql(exp_rslt)
  end

  it 'JSON when display_url is fb_url' do
    serializer =
      described_class.new(
        Foodbank.new(fb_name: 'local foodbank', address1: 'addr 1',
                     address2: 'addr 2', city: 'the town', state: 'OH',
                     zip: '12345', phone_public_help: '999-999-9999',
                     fb_url: 'fb_url', fb_texts: [])
      )

    exp_rslt = '{"id":null,"address":"addr 1 addr 2","city":"the town",' \
                 '"state":"OH","zip":"12345","phone":"999-999-9999",' \
                 '"name":"local foodbank","nickname":"","logo":"",' \
                 '"display_url":"fb_url","fb_agency_locator_url":"",' \
                 '"fb_url":"fb_url","fb_fano_url":null,"fb_texts":[]}'
    expect(serializer.to_json).to eql(exp_rslt)
  end

  it 'JSON when display_url is fb_fano_url' do
    serializer =
      described_class.new(
        Foodbank.new(fb_name: 'local foodbank', address1: 'addr 1',
                     address2: 'addr 2', city: 'the town', state: 'OH',
                     zip: '12345', phone_public_help: '999-999-9999',
                     fb_fano_url: 'fb_fano_url', fb_texts: [])
      )

    exp_rslt = '{"id":null,"address":"addr 1 addr 2","city":"the town",' \
                 '"state":"OH","zip":"12345","phone":"999-999-9999",' \
                 '"name":"local foodbank","nickname":"","logo":"",' \
                 '"display_url":"fb_fano_url",' \
                 '"fb_agency_locator_url":"","fb_url":"",' \
                 '"fb_fano_url":"fb_fano_url","fb_texts":[]}'
    expect(serializer.to_json).to eql(exp_rslt)
  end
end
