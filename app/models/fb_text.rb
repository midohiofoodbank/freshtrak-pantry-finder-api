# frozen_string_literal: true

# Foodbank, associated to many pantries
class FbText < ApplicationRecord
  self.table_name = 'fb_text'
  belongs_to :foodbank, foreign_key: :fb_id, inverse_of: :fb_texts
end
