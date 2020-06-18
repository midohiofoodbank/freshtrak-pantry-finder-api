# frozen_string_literal: true

module Api
  # Controller to expose Event Hours
  class EventHoursController < Api::BaseController
    before_action :set_event_date, only: %i[show index]
    before_action :set_event_hour, only: %i[show]

    # GET api/event_hours
    # GET api/event_dates/:id/event_hours
    def index
      if params.key?(:event_date_id)
        render json: ActiveModelSerializers::SerializableResource.new(
          @event_date, event_hours: true, event_slots: true
        ).as_json
      else
        render json: ActiveModelSerializers::SerializableResource.new(
          EventHour.distinct.limit(100)
        ).as_json
      end
    end

    # GET /api/event_hours/:id
    def show
      render json:
        ActiveModelSerializers::SerializableResource.new(@event_hour).as_json
    end

    private

    def set_event_date
      return unless params[:event_date_id]

      @event_date = EventDate.find(params[:event_date_id])
    end

    def set_event_hour
      @event_hour = EventHour.find(params[:id] || params[:event_hour_id])
    end
  end
end
