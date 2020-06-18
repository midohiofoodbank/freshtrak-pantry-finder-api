# frozen_string_literal: true

describe Api::BaseController, type: :controller do
  describe '#show - exception handling' do
    context 'when record does not exists' do
      it 'throws error message' do
        get '/api/events/-1'
        expect(response.status).to eq 404
        expect(JSON.parse(response.body)['message']).to eq(
          "Couldn't find Record"
        )
      end
    end
  end
end
