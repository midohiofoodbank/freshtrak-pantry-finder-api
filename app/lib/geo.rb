# frozen_string_literal: true

# Shared geographic calculations
module Geo
  class << self
    # calculates distance between two coordinates
    # abstracted from Geocoder
    def dist_btn_coords(lat1, long1, lat2, long2)
      Geocoder::Calculations.distance_between([lat1, long1],
                                              [lat2, long2]).round(2)
    end

    # returns latitude for zip_code centroid coordinate
    def zip_lat(zip_code)
      ZipCode.find_by(zip_code: zip_code).latitude.to_f
    end

    # returns longitude for zip_code centroid coordinate
    def zip_long(zip_code)
      ZipCode.find_by(zip_code: zip_code).longitude.to_f
    end
  end
end
