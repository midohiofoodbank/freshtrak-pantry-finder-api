# frozen_string_literal: true

# Shared geographic calculations and validations
module Geo
  class << self
    ##
    # Distance Between two location objects
    #
    # Accepts two objects of any type that contain a
    # lat and long method.
    #   location        object
    #   other_location  object
    #
    # Returns the distance between these two objects
    def distance_between(location, other_location)
      return '' if location.nil? || other_location.nil? ||
                   !valid_locations(location, other_location)

      haversine_distance_between(location.lat,
                                 location.long,
                                 other_location.lat,
                                 other_location.long, true)
    end

    ##
    # Haversine Distance Calculation
    #
    # Accepts the latitude and longitude of two locations
    #   lat1  float
    #   lon1  float
    #   lat2  float
    #   lon2  float
    #
    # Returns the distance between these two
    # points in either miles or kilometers
    # rubocop:disable Metrics/AbcSize
    def haversine_distance_between(lat1, lon1, lat2, lon2, miles)
      # Calculate radial arcs for latitude and longitude
      d_lat = (lat2 - lat1) * Math::PI / 180
      d_lon = (lon2 - lon1) * Math::PI / 180

      a = Math.sin(d_lat / 2)**2 +
          Math.cos(lat1 * Math::PI / 180) *
          Math.sin(d_lon / 2)**2 *
          Math.cos(lat2 * Math::PI / 180)

      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

      (6371 * c * (miles ? 1 / 1.6 : 1)).round(2)
    end
    # rubocop:enable Metrics/AbcSize

    def valid_locations(location, other_location)
      valid_coordinate(location.lat.to_s, location.long.to_s) &&
        valid_coordinate(other_location.lat.to_s, other_location.long.to_s)
    end

    def valid_coordinate(lat, long)
      lat && long &&
        StringUtils.numeric?(lat) && StringUtils.numeric?(long) &&
        valid_coordinate_values(lat.to_f, long.to_f)
    end

    def valid_coordinate_values(lat, long)
      (lat >= -90 && lat <= 90) && (long >= -180 && long <= 180)
    end
  end
end
