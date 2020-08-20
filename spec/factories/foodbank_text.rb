# frozen_string_literal: true

FactoryBot.define do
  factory :foodbank_text do
    fb_id { 0 }
    order { 50 }
    date_added { 'CURRENT_TIMESTAMP' }
    added_by { 0 }
    status_id { 1 }
    text { Faker::Lorem.paragraph }
    link_text { Faker::Lorem.paragraph }
    link_href { Faker::Internet.url }
    image_resource { Faker::Internet.url }
    foodbank
  end
end
