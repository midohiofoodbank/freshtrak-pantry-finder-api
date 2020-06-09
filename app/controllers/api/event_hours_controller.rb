# frozen_string_literal: true

module Api
  # Controller to expose Event Hours
  class EventHoursController < ApplicationController
    before_action :set_event_date, only: %i[show index]

    # GET api/event_hours
    # GET api/event_dates/:id/event_hours
    def index
      if params.key?(:event_date_id)
        set_event_date
        render json: ActiveModelSerializers::SerializableResource.new(
          @event_date, event_hours: true, event_slots: true
        ).as_json
      else
        render json: ActiveModelSerializers::SerializableResource.new(
          EventHour.distinct
        ).as_json
      end
    end

    # GET /api/event_hours/:id
    def show
      set_event_date
      render json:
        ActiveModelSerializers::SerializableResource.new(@event_date).as_json
    end

    private

    def set_event_date
      @event_date = EventDate.find(params[:event_date_id])
    end
  end
end
