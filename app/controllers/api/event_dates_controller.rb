# frozen_string_literal: true

module Api
  # Controller to expose Event Dates
  class EventDatesController < ApplicationController
    before_action :set_event_date, only: [:show]

    # GET /api/event_dates/1
    def show
      render json:
        ActiveModelSerializers::SerializableResource.new(@event_date).as_json
    end

    private

    def set_event_date
      @event_date = EventDate.find(params[:id])
    end
  end
end
