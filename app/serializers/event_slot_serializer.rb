# frozen_string_literal: true

# Defines EventSlot attributes to be returned in JSON
class EventSlotSerializer < ApplicationSerializer
  attributes :event_slot_id, :start_time, :end_time, :open_slots
end
