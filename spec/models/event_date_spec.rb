# frozen_string_literal: true

describe EventDate, type: :model do
  let(:event_date) { create(:event_date) }

  it 'belongs to an event' do
    expect(event_date.event).to be_an_instance_of(Event)
  end

  it 'has many event hours' do
    event_hours =
      5.times.map { create(:event_hour, event_date: event_date) }

    expect(event_date.event_hours.pluck(:id)).to eq(event_hours.pluck(:id))
  end

  context 'with scopes' do
    it 'defaults to dates in the future' do
      create(:event_date,
             event_date_key: (Date.today - 2).to_s.delete('-'))

      expected_event_id = event_date.id
      expect(described_class.all.pluck(:id)).to eq([expected_event_id])
    end

    it 'defaults to dates that have been published' do
      create(:event_date, status_publish: 1,
                          published_date_key: (Date.today + 2).to_s.delete('-'))
      create(:event_date, status_publish: 0,
                          published_date_key: (Date.today - 2).to_s.delete('-'))

      expected_event_id = event_date.id
      expect(described_class.all.pluck(:id)).to eq([expected_event_id])
    end

    it 'defaults to active events' do
      create(:event_date, status_id: 0)

      expected_id = event_date.id
      expect(described_class.all.pluck(:id)).to eq([expected_id])
    end

    it 'defaults to dates for events that publish dates' do
      event = create(:event, status_publish_event_dates: 0)
      create(:event_date, event: event)

      expected_id = event_date.id
      expect(described_class.all.pluck(:id)).to eq([expected_id])
    end

    it 'includes events today in the future scope' do
      event_today = create(:event_date,
                           event_date_key: Date.today.to_s.delete('-'))

      expect(described_class.future.pluck(:id)).to eq([event_today.id])
    end

    it 'ignores event dates for events that do not publish dates' do
      event = create(:event, status_publish_event_dates: 0)
      create(:event_date, event: event)

      expect(described_class.event_publishes_dates).to be_empty
    end

    it 'ignores event dates where current datetime > published_end_datetime' do
      # create event_date with published_end_datetime two days in the past
      create(:event_date, published_end_datetime:
             (DateTime.current - 2).utc.strftime('%Y-%m-%d %H:%M:%S'))

      expect(described_class.active).to be_empty
    end

    it 'accepts event dates where current datetime == published_end_datetime' do
      create(:event_date, published_end_datetime:
             DateTime.current.utc.strftime('%Y-%m-%d %H:%M:%S'))

      expect(described_class.active).not_to be_empty
    end

    it 'accepts event dates where current datetime < published_end_datetime' do
      create(:event_date, published_end_datetime:
             (DateTime.current + 2).utc.strftime('%Y-%m-%d %H:%M:%S'))

      expect(described_class.active).not_to be_empty
    end

    it 'validates capacity less than reserved' do
      event_date1 = create(:event_date, capacity: 10, reserved: 10)
      event_date2 = create(:event_date, capacity: 10, reserved: 5)

      expect(event_date1.capacity_not_full?).to eq(false)
      expect(event_date2.capacity_not_full?).to eq(true)
    end

    it 'validates if reservations still open ' do
      event_date1 = create(:event_date, published_end_datetime:
        (DateTime.current.utc - 1.day).strftime('%Y-%m-%d %H:%M:%S'))
      event_date2 = create(:event_date, published_end_datetime:
        (DateTime.current.utc + 1.day).strftime('%Y-%m-%d %H:%M:%S'))

      expect(event_date1.still_open?).to eq(false)
      expect(event_date2.still_open?).to eq(true)
    end

    it 'validates if event is published ' do
      event_date1 = create(:event_date, published_date_key:
                          (Date.current + 1.day).to_s.delete('-').to_i)
      event_date2 = create(:event_date, published_date_key:
        (Date.current - 2.days).to_s.delete('-').to_i)

      expect(event_date1.published?).to eq(false)
      expect(event_date2.published?).to eq(true)
    end

    it 'validates and checks if capacity published and event is still open ' do
      event_date1 = create(
        :event_date,
        capacity: 10,
        reserved: 10,
        published_date_key: (Date.today + 1.day).to_s.delete('-').to_i
      )
      event_date2 = create(
        :event_date,
        capacity: 10,
        reserved: 10,
        published_end_datetime: (DateTime.current.utc - 1.day)
          .strftime('%Y-%m-%d %H:%M:%S')
      )
      errors1 = event_date1.validate_registration
      errors2 = event_date2.validate_registration

      expect(errors1[0]).to eq('Event is not published')
      expect(errors1[1]).to eq('Reservation is full')

      expect(errors2[0]).to eq('Reservation is full')
      expect(errors2[1]).to eq('Reservation is closed')
    end

    it 'errors out if event date is valid ' do
      event_date1 = create(
        :event_date,
        capacity: 10,
        reserved: 5,
        published_end_datetime: (DateTime.current.utc + 1.day)
          .strftime('%Y-%m-%d %H:%M:%S')
      )
      errors = event_date1.validate_registration

      expect(errors.count).to eq(0)
    end
  end
end
