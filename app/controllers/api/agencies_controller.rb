# frozen_string_literal: true

module Api
  # Exposes the Agency location data
  class AgenciesController < Api::BaseController
    before_action :permit_params
    before_action :set_agencies, only: [:index]
    before_action :set_user_location, only: [:index]
    before_action :set_agency, only: [:show]

    def index
      by_zip(@zip)

      by_event_date_on_or_after(@event_date)

      by_event_date_on(@event_date_on)

      render json: serialized_agencies
    end

    # GET /api/agencies/:id
    def show
      render json:
        ActiveModelSerializers::SerializableResource.new(@agency).as_json
    end

    private

    def permit_params
      params.permit(
        :zip_code, :event_date, :event_date_on, :lat, :long
      ).tap do |param|
        @zip = param[:zip_code]
        @event_date = param[:event_date]
        @event_date_on = param[:event_date_on]
        @lat = param[:lat]
        @long = param[:long]
      end
    end

    def set_agencies
      @agencies =
        if !@zip && !@event_date && !@event_date_on
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
                                                       zip_code: @zip)
                                                  .as_json
    end

    def by_zip(zip)
      return unless zip

      @agencies = @agencies.by_zip_code(zip)
    end

    def by_event_date_on_or_after(event_date_after)
      return unless event_date_after

      @agencies = @agencies.with_event_after(event_date_after.delete('-'))
    end

    def by_event_date_on(event_date_on)
      return unless event_date_on

      @agencies = @agencies.with_event_on(event_date_on.delete('-'))
    end
  end
end
