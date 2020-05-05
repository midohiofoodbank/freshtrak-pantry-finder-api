# frozen_string_literal: true

# Shared geographic calculations
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
      return '' if location.nil? || other_location.nil?

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
    def haversine_distance_between(lat1, lon1, lat2, lon2, miles)
      # Calculate radial arcs for latitude and longitude
      d_lat = (lat2 - lat1) * Math::PI / 180
      d_lon = (lon2 - lon1) * Math::PI / 180

      haversine_a = haversine_a(d_lat, d_lon, lat1, lat2)

      c = haversine_c(haversine_a)

      (6371 * c * (miles ? 1 / 1.6 : 1)).round(2)
    end

    def haversine_a(d_lat, d_lon, lat1, lat2)
      Math.sin(d_lat / 2)**2 +
        Math.cos(lat1 * Math::PI / 180) *
        Math.sin(d_lon / 2)**2 *
        Math.cos(lat2 * Math::PI / 180)
    end

    def haversine_c(haversine_a)
      2 * Math.atan2(Math.sqrt(haversine_a), Math.sqrt(1 - haversine_a))
    end

    def validate_coordinate_values(lat, long)
      return false unless (lat >= -90 && lat <= 90) &&
                          (long >= -180 && long <= 180)

      true
    end
  end
end
