# frozen_string_literal: true

# Defines Event attributes to be returned in JSON
class EventSerializer < ActiveModel::Serializer
  attributes :id, :address, :city, :state, :zip
  attribute :loc_id, key: :agency_id
  attribute :pt_latitude, key: :latitude
  attribute :pt_longitude, key: :longitude
  attribute :event_name, key: :name
  attribute :service_description, key: :service

  has_many :event_dates

  def address
    return object.address1 if object.address2.nil?

    "#{object.address1} #{object.address2}"
  end

  # serialize instances of distance through model
  attribute :estimated_distance do
    object.estimated_distance(@instance_options[:loc_lat],
                              @instance_options[:loc_long])
  end
end
