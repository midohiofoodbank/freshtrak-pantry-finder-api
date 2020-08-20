# frozen_string_literal: true

# Foodbank, associated to many Foodbank Texts
class FoodbankText < ApplicationRecord
  self.table_name = 'fb_text'

  belongs_to :foodbank, foreign_key: :fb_id, inverse_of: :foodbank_texts

  default_scope { active }
  scope :active, -> { where(status_id: 1) }
end
