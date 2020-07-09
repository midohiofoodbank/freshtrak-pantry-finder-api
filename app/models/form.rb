# frozen_string_literal: true

# Form, associated with an event
class Form < ApplicationRecord
  alias_attribute :id, :form_id

  belongs_to :event, primary_key: :form_master_num,
                     foreign_key: :form_master_num, inverse_of: :forms

  default_scope { active.language.within_range }
  scope :active, -> { where(status_id: 1) }
  # limit to language_id == 1 (english)
  scope :language, -> { where(language_id: 1) }
  scope :within_range, lambda {
    where('? between effective_start and effective_end', Date.today)
  }

  def display_age_adult
    max_age_child + 1 || ''
  end

  def display_age_senior
    max_age_adult + 1 || ''
  end
end
