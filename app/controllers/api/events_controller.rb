# frozen_string_literal: true

module Api
  # Controller to expose Events
  class EventsController < Api::BaseController
    before_action :set_events, only: [:index]
    before_action :set_user_location, only: [:index]
    before_action :set_event, only: [:show]

    def index
      @events = @events.by_zip_code(@zip) if (@zip = search_params[:zip_code])
      if (date = search_params[:event_date])
        @events = @events.with_event_after(date.delete('-'))
      end
      if (@service = search_params[:service])
        @events = @events.by_service_category(@service)
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
      params.permit(:zip_code, :event_date, :lat, :long, :service)
    end

    def set_events
      @events =
        if !search_params[:zip_code] && !search_params[:event_date] &&
           !search_params[:service]
          Event.none
        else
          Event.distinct
        end
    end

    def set_event
      @event = Event.find(params[:id])
    end

    # set_user_location loads the objects used to return distance.
    # Valid :lat :long parameters will take precedence over the
    # :zip_code paramter (used to calculate distance from the zip code
    # (centroid)
    def set_user_location
      return unless (search_params[:lat] && search_params[:long]) ||
                    search_params[:zip_code]

      user_location_object(search_params[:lat], search_params[:long],
                           search_params[:zip_code])
    end

    def user_location_object(lat, long, zip_code)
      if Geo.valid_coordinate(lat, long)
        @user_location = OpenStruct.new(lat: lat.to_f, long: long.to_f)
      elsif zip_code
        @user_location = ZipCode.find_by(zip_code: zip_code)
      end
    end

    def serialized_events
      ActiveModelSerializers::SerializableResource.new(@events,
                                                       user_location:
                                                       @user_location,
                                                       zip_code: @zip)
                                                  .as_json
    end
  end
end
