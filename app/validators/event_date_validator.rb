# frozen_string_literal: true

# validations on event_date object
class EventDateValidator < ActiveModel::Validator
  include ActiveModel::Serialization
  def validate(record)
    published?(record)
    capacity?(record)
    still_open?(record)
  end

  def published?(record)
    return if record.published?

    record.errors.add(:event_date, 'event is not published')
  end

  def capacity?(record)
    return if record.open_slots.positive?

    record.errors.add(:event_date, 'event is at capacity')
  end

  def still_open?(record)
    return if record.still_open?

    record.errors.add(:event_date, 'event expired and reservations closed')
  end
end
