# frozen_string_literal: true

# Serializer to strip away the cruft in the foodbanks Texts table
class FoodbankTextSerializer < ActiveModel::Serializer
  attributes :id, :image_resource, :text, :link_text, :link_href, :order
  attributes :show_eligibilty_box
  attributes :eligibility_header, :eligibility_body, :eligibility_footer
end
