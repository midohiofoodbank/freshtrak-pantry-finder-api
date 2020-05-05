# frozen_string_literal: true

module Api
  # Exposes the Agency location data
  class AgenciesController < ApplicationController
    before_action :set_agencies, only: [:index]

    def index
      user_location
      if (zip = search_params[:zip_code])
        @agencies = @agencies.by_zip_code(zip)
      end
      if (date = search_params[:event_date])
        @agencies = @agencies.with_event_after(date.delete('-'))
      end

      render json: serialized_agencies
    end

    private

    def search_params
      params.permit(:zip_code, :event_date, :lat, :long)
    end

    def set_agencies
      @agencies =
        if !search_params[:zip_code] && !search_params[:event_date]
          Agency.none
        else
          Agency.distinct
        end
    end

    # user_location loads the objects used to return distance.
    # Valid :lat :long parameters will take precedence over the
    # :zip_code paramter (used to calculate distance from the zip code
    # (centroid)
    def user_location
      return unless (search_params[:lat] && search_params[:long]) ||
                    search_params[:zip_code]

      user_location_lat_long(search_params[:lat], search_params[:long])
      return if @user_location

      user_location_zip
    end

    def user_location_lat_long(lat, long)
      return unless lat && long

      return unless validate_coordinate(lat, long) == true

      @user_location = OpenStruct.new(lat: lat.to_f,
                                      long: long.to_f)
    end

    def user_location_zip
      return unless search_params[:zip_code]

      @user_location = ZipCode.find_by(zip_code: search_params[:zip_code])
    end

    def validate_coordinate(lat, long)
      return false unless lat.numeric? == true && long.numeric? == true

      Geo.validate_coordinate_values(lat.to_f, long.to_f)
    end

    def serialized_agencies
      ActiveModelSerializers::SerializableResource.new(@agencies,
                                                       user_location:
                                                       @user_location)
                                                  .as_json
    end
  end
end
