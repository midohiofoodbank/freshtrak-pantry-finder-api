# frozen_string_literal: true

# Defines service_category, attributes to be returned in JSON
class ServiceCategorySerializer < ApplicationSerializer
  attribute :id
  attribute :service_category_name
end
