# frozen_string_literal: true

module Api
  # Controller to expose Events
  class EventsController < Api::BaseController
    before_action :set_events, only: [:index]
    before_action :set_event, only: [:show]

    def index
      if (@event_date_id = search_params[:event_date_id])
        @events = @events.with_event_date_id(@event_date_id)
      end

      render json: serialized_events
    end

    # GET /api/events/:id
    def show
      render json:
        ActiveModelSerializers::SerializableResource.new(@event).as_json
    end

    private

    def search_params
      params.permit(:event_date_id)
    end

    def set_events
      @events =
        if !search_params[:event_date_id]
          Event.none
        else
          Event.distinct
        end
    end

    def set_event
      @event = Event.find(params[:id])
    end

    def serialized_events
      ActiveModelSerializers::SerializableResource.new(@events).as_json
    end
  end
end
