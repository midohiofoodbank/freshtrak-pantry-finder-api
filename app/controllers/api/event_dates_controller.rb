# frozen_string_literal: true

class Api::EventDatesController < ApplicationController
  before_action :set_event_date, only: [:show]

  # GET /api/event_dates/1
  def show
    render json: @event_date
  end

  private

  def set_event_date
    @event_date = EventDate.find(params[:id])
  end
end
