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
      render json:
        ActiveModelSerializers::SerializableResource.new(
          @event_date.event
        ).as_json
    end

    private

    def set_event_date
      # unscope to handle scoped validation errors
      @event_date = EventDate.unscoped.find(params[:event_date_id])
      if @event_date.valid?
        # perform unscoped find to catch record_not_found exception
        EventDate.find(params[:event_date_id])
      else
        render json: { errors: @event_date.errors }
      end
    end
  end
end
