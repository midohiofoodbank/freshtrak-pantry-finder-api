# frozen_string_literal: true

# Defines EventHour attributes to be returned in JSON
class EventHourSerializer < ActiveModel::Serializer
  attributes :event_hour_id, :start_time_key, :end_time_key, :open_slots

  def open_slots
    object&.open_slots
  end

  has_many :event_slots, if: -> { should_render_association }

  def should_render_association
    @instance_options.key?(:event_slots) ? true : false
  end
end
