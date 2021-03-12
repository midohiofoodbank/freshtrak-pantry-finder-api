# frozen_string_literal: true

# Serializer to strip away the cruft in the event_dates table
class EventDateSerializer < ApplicationSerializer
  attributes :id, :event_id, :capacity, :reserved
  attributes :accept_walkin, :accept_reservations, :accept_interest
  attribute :start_time
  attribute :end_time

  attribute :date do
    Date.parse(object.date.to_s)
  end

  has_many :event_hours, if: -> { @instance_options[:event_hours] }
end
