# frozen_string_literal: true

FactoryBot.define do
  factory :form do
    form_master_num { 'oh_jfs_04221' }
    language_id { 1 }
    effective_start { Date.today.to_s }
    effective_end { Date.today.to_s }
    predesessor_id { 1 }
    successor_id { 2 }
    date_added { Date.today.to_s.delete('-') }
    max_age_child { 17 }
    max_age_adult { 59 }
    status_id { 1 }

    event
  end
end
