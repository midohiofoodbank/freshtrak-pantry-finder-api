# frozen_string_literal: true

FactoryBot.define do
  factory :fb_text do
    fb_id { 0 }
    order { 50 }
    date_added { 'CURRENT_TIMESTAMP' }
    added_by { 0 }
    status_id { 1 }
    text { 'The piece of text the foodbank wants to show on FreshTrak' }
    link_text { 'The inner content of <a></a> tag' }
    link_href { 'The href property of an <a></a> tag' }
    image_resource { 'The location of an externally hosted' }
    foodbank
  end
end
