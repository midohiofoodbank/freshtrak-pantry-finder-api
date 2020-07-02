# frozen_string_literal: true

# Form, associated with an event
class Form < ApplicationRecord
  alias_attribute :id, :form_id

  belongs_to :event, primary_key: :form_master_num,
                     foreign_key: :form_master_num, inverse_of: :forms

  default_scope { active.within_range }
  scope :active, -> { where(status_id: 1) }

  scope :within_range, lambda {
    where('? between effective_start and effective_end', Date.today.to_s)
  }
end
