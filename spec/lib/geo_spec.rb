# frozen_string_literal: true

# Test the Geo.distance_between method with known coordinates both valid
# and invalid to ensure distance values are what they should be.
#
# Note: if the underlying algorithm changes, e.g., move to driving distance
# method or more accurate Haversine formula, etc., the expected distances may
# change and the expected values will need to change accordingly

describe Geo do
  it 'Distance_between Powell Ohio location and Mid Ohio Foodbank' do
    location = OpenStruct.new(lat: 40.146000, long: -83.075890)
    other_location = OpenStruct.new(lat: 39.8862352, long: -83.05538713)

    expect(described_class.distance_between(location,
                                            other_location)).to eq(18.09)
  end

  it 'Distance_between Mid Ohio Foodbank and Buckey Lake LEADS agency' do
    location = OpenStruct.new(lat: 39.8862352, long: -83.05538713)
    other_location = OpenStruct.new(lat: 39.9329099, long: -82.4814454)

    expect(described_class.distance_between(location,
                                            other_location)).to eq(30.77)
  end

  it 'Distance between a nil location and Buckeye Lake LEADS agencty' do
    location = nil
    other_location = OpenStruct.new(lat: 39.9329099, long: -82.4814454)
    expect(described_class.distance_between(location,
                                            other_location)).to eq('')
  end

  it 'Distance between non-numeric coordinate and Buckeye Lake Leads agency' do
    location = OpenStruct.new(lat: 'dog', long: 'cat')
    other_location = OpenStruct.new(lat: 39.932396, long: -82.481078)

    expect(described_class.distance_between(location,
                                            other_location)).to eq('')
  end

  it 'distance between a location in Powell Ohio and an invalid coordinate' do
    location = OpenStruct.new(lat: 40.146000, long: -83.075890)
    other_location = OpenStruct.new(lat: 101.78, long: -190.3)

    expect(described_class.distance_between(location,
                                            other_location)).to eq('')
  end
end
