# frozen_string_literal: true

# Serializer to strip away the cruft in the foodbanks table
class FbTextSerializer < ActiveModel::Serializer
  attributes :id, :image_resource, :text, :link_text, :link_href, :order
end
