# frozen_string_literal: true

module Api
  # Exposes the Agency location data
  class AgenciesController < Api::BaseController
    before_action :set_agencies, only: [:index]
    before_action :set_user_location, only: [:index]
    before_action :set_agency, only: [:show]

    def index
      if (@zip = search_params[:zip_code])
        @agencies = @agencies.by_zip_code(@zip)
      end
      if (date = search_params[:event_date])
        @agencies = @agencies.with_event_after(date.delete('-'))
      end
      by_zip_and_event_date_on(
        search_params[:zip_code], search_params[:event_date_on]
      )

      render json: serialized_agencies
    end

    # GET /api/agencies/:id
    def show
      render json:
        ActiveModelSerializers::SerializableResource.new(@agency).as_json
    end

    private

    def search_params
      params.permit(:zip_code, :event_date, :event_date_on, :lat, :long)
    end

    def set_agencies
      @agencies =
        if !search_params[:zip_code] && !search_params[:event_date] &&
           !search_params[:event_date_on]
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

    def serialized_agencies
      ActiveModelSerializers::SerializableResource.new(@agencies,
                                                       user_location:
                                                       @user_location,
                                                       zip_code: @zip)
                                                  .as_json
    end

    def by_zip_and_event_date_on(zip_code, event_date_on)
      return unless zip_code && event_date_on

      @agencies = @agencies.by_zip_code(zip_code)
                           .with_event_on(event_date_on.delete('-'))
    end
  end
end
