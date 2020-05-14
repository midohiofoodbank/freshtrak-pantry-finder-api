# frozen_string_literal: true

# includes exception notes for geographic areas
class EventGeography < ApplicationRecord
  self.table_name = 'event_geography_profiles'

  alias_attribute :id, :egp_id

  has_many :event_zip_codes, foreign_key: :egp_id, inverse_of: :event_geography,
                             dependent: :restrict_with_exception

  default_scope { active }
  scope :active, -> { where(status_id: 1) }

  def self.exception_notes_hash
    EventGeography.joins(:event_zip_codes)
                  .where(event_service_geographies:
                  { trigger_exception_note: 1 })
                  .pluck(:exception_note, :event_id).to_h
  end
end
