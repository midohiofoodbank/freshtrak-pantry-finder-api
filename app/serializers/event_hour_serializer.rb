# frozen_string_literal: true

# Defines EventHour attributes to be returned in JSON
class EventHourSerializer < ApplicationSerializer
  attributes :event_hour_id, :start_time, :end_time, :open_slots

  has_many :event_slots, if: -> { @instance_options[:event_slots] }
end
