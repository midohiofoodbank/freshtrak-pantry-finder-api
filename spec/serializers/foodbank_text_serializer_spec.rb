# frozen_string_literal: true

describe FoodbankTextSerializer do
  context 'with attributes' do
    let(:foodbank_text) { create(:foodbank_text) }

    it 'includes fb texts attributes' do
      serialized_object = JSON.parse(described_class.new(foodbank_text).to_json)
      serialized_object.should == expected_attributes
    end

    def expected_attributes
      {
        'id' => foodbank_text.id,
        'image_resource' => foodbank_text.image_resource,
        'text' => foodbank_text.text,
        'link_text' => foodbank_text.link_text,
        'link_href' => foodbank_text.link_href,
        'order' => foodbank_text.order,
        'show_eligibilty_box' => foodbank_text.show_eligibilty_box,
        'eligibility_header' => foodbank_text.eligibility_header,
        'eligibility_body' => foodbank_text.eligibility_body,
        'eligibility_footer' => foodbank_text.eligibility_footer
      }
    end
  end
end
