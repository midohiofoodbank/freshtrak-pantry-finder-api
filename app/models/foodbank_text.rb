# frozen_string_literal: true

# Foodbank, associated to many Foodbank Texts
class FoodbankText < ApplicationRecord
  self.table_name = 'fb_text'
  belongs_to :foodbank, foreign_key: :fb_id, inverse_of: :foodbank_texts
end
