# frozen_string_literal: true

describe Api::EventSlotsController, type: :controller do
  let(:capacity) { 10 }
  let(:event_slot) { create(:event_slot, capacity: capacity) }

  it 'shows the event date' do
    get "/api/event_slots/#{event_slot.id}"

    event_slot_response = JSON.parse(response.body)['event_slot']
    expect(event_slot_response['event_slot_id']).to eq(event_slot.id)
    expect(event_slot_response['capacity']).to eq(capacity)
  end
end
