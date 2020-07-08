# frozen_string_literal: true

describe Form, type: :model do
  let(:form) { create(:form) }

  it 'belongs to an event' do
    expect(form.event).to be_an_instance_of(Event)
  end

  context 'with scopes' do
    it 'defaults to active forms' do
      active = create(:form, status_id: 1)
      create(:form, status_id: 0)
      expected_id = active.id
      expect(described_class.all.pluck(:id)).to eq([expected_id])
    end

    it 'does not include results before effective start' do
      create(:form, effective_start: (Date.today + 1),
                    effective_end: (Date.today + 5))

      expect(described_class.within_range).to be_empty
    end

    it 'does not include results after effective end' do
      create(:form, effective_start: (Date.today - 10),
                    effective_end: (Date.today - 5))

      expect(described_class.within_range).to be_empty
    end

    it 'includes results within effective range' do
      create(:form, effective_start: (Date.today - 10),
                    effective_end: (Date.today + 10))

      expect(described_class.within_range).not_to be_empty
    end
    
    it 'includes results on effective start date' do
      create(:form, effective_start: (Date.today),
                    effective_end: (Date.today + 10))

      expect(described_class.within_range).not_to be_empty
    end

    it 'includes results on effective end date' do
        create(:form, effective_start: (Date.today - 10),
                      effective_end: (Date.today))
  
        expect(described_class.within_range).not_to be_empty
    end
  end
end
