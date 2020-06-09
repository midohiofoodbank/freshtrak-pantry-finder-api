# frozen_string_literal: true

# Defines EventSlot attributes to be returned in JSON
class EventSlotSerializer < ActiveModel::Serializer
  attributes :event_slot_id, :start_time_key, :end_time_key, :open_slots

  def open_slots
    object&.open_slots
  end
end
