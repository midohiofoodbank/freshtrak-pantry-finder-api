# frozen_string_literal: true

# Defines EventSlot attributes to be returned in JSON
class EventSlotSerializer < ApplicationSerializer
  attributes :event_slot_id, :capacity, :reserved, :start_time, :end_time, :open_slots
end
