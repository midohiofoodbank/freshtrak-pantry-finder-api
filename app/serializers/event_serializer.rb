# frozen_string_literal: true

# Defines Event attributes to be returned in JSON
class EventSerializer < ActiveModel::Serializer
  attributes :id, :address, :city, :state, :zip
  attribute :loc_id, key: :agency_id
  attribute :pt_latitude, key: :latitude
  attribute :pt_longitude, key: :longitude
  attribute :event_name, key: :name
  attribute :service_description, key: :service
  attributes :estimated_distance, :exception_note, :event_details

  has_many :event_dates

  def address
    return object.address1 if object.address2.nil?

    "#{object.address1} #{object.address2}"
  end

  # calculate estimated distance JSON field using the user
  # location and the model object location.  User location is
  # an object representing a location known by the user, e.g.,
  # zip code, lat/long derived from address, etc
  def estimated_distance
    user_location = @instance_options[:user_location]
    return '' if user_location.nil?

    Geo.distance_between(user_location, object)
  end

  def exception_note
    exception_notes = EventZipCode.exception_note(@instance_options[:zip_code],
                                                  object.id)
    # Only expecting one exeption_note
    exception_notes[0] || ''
  end

  def event_details
    object.pub_desc_long || ''
  end
end
