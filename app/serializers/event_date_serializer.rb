# frozen_string_literal: true

# Serializer to strip away the cruft in the event_dates table
class EventDateSerializer < ApplicationSerializer
  attributes :id, :event_id, :capacity
  attributes :accept_walkin, :accept_reservations, :accept_interest
  attribute :start_time
  attribute :end_time

  attribute :date do
    Date.parse(object.date.to_s)
  end

  has_many :event_hours, if: -> { should_render_association }

  def should_render_association
    @instance_options.key?(:event_hours) ? true : false
  end
end
