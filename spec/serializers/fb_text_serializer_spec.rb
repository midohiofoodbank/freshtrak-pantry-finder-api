# frozen_string_literal: true

describe FbTextSerializer do
  context 'with attributes' do
    let(:fb_text) { create(:fb_text) }

    it 'includes fb texts attributes' do
      serialized_object = JSON.parse(described_class.new(fb_text).to_json)
      serialized_object.should == expected_attributes
    end

    def expected_attributes
      {
        'id' => fb_text.id,
        'image_resource' => fb_text.image_resource,
        'text' => fb_text.text,
        'link_text' => fb_text.link_text,
        'link_href' => fb_text.link_href,
        'order' => fb_text.order
      }
    end
  end
end
