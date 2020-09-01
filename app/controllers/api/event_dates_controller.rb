# frozen_string_literal: true

module Api
  # Controller to expose Event Dates
  class EventDatesController < Api::BaseController
    before_action :set_event_date, only: [:show, :event_details]

    # GET /api/event_dates/:id
    def show
      render json:
        ActiveModelSerializers::SerializableResource.new(
          @event_date, event_hours: true, event_slots: true
        ).as_json
    end

    def event_details
      puts @event_date.inspect
      if @event_date.valid_registration
        render json: ActiveModelSerializers::SerializableResource.new(@event_date.event).as_json
      else
        render json: {error: "Registration is not allowed."}
      end
    end

    private

    def set_event_date
      @event_date = EventDate.find(params[:event_date_id])
    end
  end
end
