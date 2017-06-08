require 'rails_helper'

RSpec.describe WestfieldSwagger::SwaggerController, type: :controller do
  routes { WestfieldSwagger::Engine.routes }

  describe '#index' do
    context 'swagger documentation' do

      it 'parses a service swagger yml file and renders the resulting json' do
        get :index, format: :json, version: '1', service: 'some_service'
        expect(response).to have_http_status(200)
        parsed_response = JSON.parse(response.body)
        expect(response.content_type).to eql('application/json')
        expect(parsed_response['swagger']).to eql('2.0')
        expect(parsed_response['host']).to eql('my-custom-hostname-goes-here.domain.com')
      end

      it 'parses a roll-up swagger yml file and renders the resulting json' do
        get :index, format: :json, version: '1'
        expect(response).to have_http_status(200)
        parsed_response = JSON.parse(response.body)
        expect(response.content_type).to eql('application/json')
        expect(parsed_response['swagger']).to eql('2.0')
        expect(parsed_response['host']).to eql('my-custom-hostname-goes-here.domain.com')
      end
    end
  end
end
