# frozen_string_literal: true

module Api
  # Controller to expose Events
  class EventsController < ApplicationController
    before_action :set_event, only: [:show]

    # GET /api/events/1
    def show
      render json:
        ActiveModelSerializers::SerializableResource.new(@event)
    end

    private

    def set_event
      @event = Event.find(params[:id])
    end
  end
end
