# frozen_string_literal: true

module Api
  # Controller to expose Event Dates
  class EventDatesController < Api::BaseController
    before_action :set_event_date, only: %i[show event_details]

    # GET /api/event_dates/:id
    def show
      render json:
        ActiveModelSerializers::SerializableResource.new(
          @event_date, event_hours: true, event_slots: true
        ).as_json
    end

    def event_details
      validation_errors = @event_date.valid_registration
      if validation_errors.empty?
        render json:
          ActiveModelSerializers::SerializableResource.new(
            @event_date.event
          ).as_json
      else
        render json: { errors: validation_errors }
      end
    end

    private

    def set_event_date
      @event_date = EventDate.find(params[:event_date_id])
    end
  end
end
