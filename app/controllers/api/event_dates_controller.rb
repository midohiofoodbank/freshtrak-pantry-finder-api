# frozen_string_literal: true

module Api
  # Controller to expose Event Dates
  class EventDatesController < Api::BaseController
    before_action :set_event_date, only: [:show]

    # GET /api/event_dates/:id
    def show
      if @event_date.valid?
        render json:
          ActiveModelSerializers::SerializableResource.new(
            @event_date, event_hours: true, event_slots: true
          ).as_json
      else
        render json: { errors: @event_date.errors }
      end
    end

    private

    def set_event_date
      @event_date = EventDate.find(params[:event_date_id])
    end
  end
end
