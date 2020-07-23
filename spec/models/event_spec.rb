# frozen_string_literal: true

describe Event, type: :model do
  let(:event) { create(:event) }

  it 'belongs to an agency' do
    expect(event.agency).to be_an_instance_of(Agency)
  end

  it 'belongs to a service type' do
    expect(event.service_type).to be_an_instance_of(ServiceType)
  end

  it 'has a service category' do
    expect(event.service_category).to be_an_instance_of(ServiceCategory)
  end

  it 'has many event dates' do
    dates = 5.times.map { create(:event_date, event: event) }

    expect(event.event_dates.pluck(:id)).to eq(dates.pluck(:id))
  end

  it 'has many forms' do
    forms = 5.times.map { create(:form, event: event) }
    expect(event.forms.pluck(:id)).to eq(forms.pluck(:id))
  end

  it 'has a service description' do
    expect(event.service_description).to eq('Choice Pantry')
  end

  it 'has an agency name' do
    expect(event.agency_name).to eq(event.agency.loc_name)
  end

  context 'with scopes' do
    it 'defaults to active and published events' do
      create(:event, status_id: 0, status_publish_event: 0)
      create(:event, status_id: 1, status_publish_event: 0)
      create(:event, status_id: 0, status_publish_event: 1)
      expected_id = event.id
      expect(described_class.all.pluck(:id)).to eq([expected_id])
    end

    it 'scopes by whether the event publishes dates' do
      create(:event, status_publish_event_dates: 0)
      expected_id = event.id
      expect(described_class.publishes_dates.pluck(:id)).to eq([expected_id])
    end

    it 'can find events through a service_category' do
      service = create(:service_category)
      events = 5.times.map do
        create(:event, service_category: service)
      end

      events_results =
        described_class.by_service_category(service.service_category)
      expect(events_results.pluck(:id)).to eq(events.pluck(:id))
    end
  end
end
