# frozen_string_literal: true

FactoryBot.define do
  factory :event_geography do
    exception_note { 'local restrictions apply' }
    added_by { 0 }
    last_update { Date.today }
    last_update_by { 0 }
  end
end
