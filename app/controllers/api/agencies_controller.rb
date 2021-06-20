# frozen_string_literal: true

module Api
  # Exposes the Agency location data
  class AgenciesController < Api::BaseController
    before_action :permit_params
    before_action :set_agencies, only: [:index]
    before_action :set_user_location, only: [:index]
    before_action :set_agency, only: [:show]

    def index
      by_zip

      by_zip_and_distance

      with_event_after

      if @agencies.blank?
        render json: {}
      else
        render json: serialized_agencies
      end
    end

    # GET /api/agencies/:id
    def show
      render json:
        ActiveModelSerializers::SerializableResource.new(@agency).as_json
    end

    private

    def permit_params
      params.permit(:zip_code, :distance, :category,
                    :event_date, :event_date_on, :lat, :long).tap do |param|
        @zip = param[:zip_code]
        @distance = param[:distance]
        @category = param[:category]
        @event_date = param[:event_date]
        @lat = param[:lat]
        @long = param[:long]
      end
    end

    def set_agencies
      @agencies =
        if !@zip && !@distance && !@event_date && !@category
          Agency.none
        else
          Agency.distinct
        end
    end

    def set_agency
      return unless params[:id]

      @agency = Agency.find(params[:id])
    end

    # set_user_location loads the objects used to return distance.
    # Valid :lat :long parameters will take precedence over the
    # :zip_code paramter (used to calculate distance from the zip code
    # (centroid)
    def set_user_location
      return unless (@lat && @long) || @zip

      user_location_object(@lat, @long, @zip)
    end

    def user_location_object(lat, long, zip_code)
      if Geo.valid_coordinate(lat, long)
        @user_location = OpenStruct.new(lat: lat.to_f, long: long.to_f)
      elsif zip_code
        @user_location = ZipCode.find_by(zip_code: zip_code)
      end
    end

    def serialized_agencies
      ActiveModelSerializers::SerializableResource.new(@agencies,
                                                       user_location:
                                                       @user_location,
                                                       zip_code: @zip,
                                                       category: @category)
                                                  .as_json
    end

    def by_zip
      return unless @zip

      @agencies = @agencies.by_zip_code(@zip)
    end

    def by_zip_and_distance
      return unless @zip && @distance

      agencies = filter_agencies_by_location
      agencies_by_event = filter_agencies_by_event_location
      @agencies = (agencies + agencies_by_event).compact.uniq
    end

    def with_event_after
      return unless @event_date

      @agencies = @agencies.with_event_after(@event_date.delete('-'))
    end

    def filter_agencies_by_location
      agencies = @agencies.by_event_address_status_id(0)
      agencies.select do |ag|
        ag.estimated_distance(@user_location).to_f < @distance.to_f
      end
    end

    def filter_agencies_by_event_location
      agencies1_ids = @agencies.by_event_address_status_id(1).collect(&:id)
      events = Event.where(loc_id: agencies1_ids)
      events.map { |ev|
        ev.agency if ev.estimated_distance(@user_location).to_f < @distance.to_f
      }
    end
  end
end
