# frozen_string_literal: true

# Defines Form, attributes to be returned in JSON
class FormSerializer < ApplicationSerializer
  attributes :id, :display_age_adult, :display_age_senior
end
