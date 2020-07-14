# frozen_string_literal: true

module Api
  # Controller to expose Event Dates
  class EventSlotsController < Api::BaseController
    before_action :set_event_slot, only: [:show]

    # GET /api/event_slots/:id
    def show
      render json:
        ActiveModelSerializers::SerializableResource.new(@event_slot).as_json
    end

    private

    def set_event_slot
      @event_slot = EventSlot.find(params[:id])
    end
  end
end
