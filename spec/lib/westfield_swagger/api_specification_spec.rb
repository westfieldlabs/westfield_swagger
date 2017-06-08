require 'rails_helper'

RSpec.describe WestfieldSwagger::ApiSpecification do
  let(:version) { '1' }
  custom_api_host = 'my-custom-api-host'

  let(:request) {
    double(:request,
      host_with_port: 'some-service.hostname.com',
      port: 0)
  }

  subject { WestfieldSwagger::ApiSpecification.new(version, nil, request) }

  describe '#read' do
    context 'info block' do
      context 'when only a single file is used for the generated swagger' do
        it 'should return the last modified date of the single file in the swagger' do
          swagger_doc = JSON.parse(subject.read)
          expect(swagger_doc["info"]["x-last_modified_at"]).to eql('2015-09-15T20:39:23Z')
        end

        it 'should return the correct name value in the info block' do
          swagger_doc = JSON.parse(subject.read)
          expect(swagger_doc["info"]["contact"]["name"]).to eql('Westfield Support')
        end
      end

      context 'when multiple files are used for the generated swagger' do
        let(:version) { '3' }

        it 'should return the last modified date of the most recent file in the swagger' do
          time = Time.parse('2001-01-01T10:10:10Z')
          Dir.glob('spec/dummy/lib/swagger/3/*.yml').each do |file|
            FileUtils.touch(file, mtime: time += 1.hour)
          end

          swagger_doc = JSON.parse(subject.read)

          expect(swagger_doc["info"]["x-last_modified_at"]).to eql(time.utc.iso8601)
        end

        it 'should deeply sort the combined swagger document' do
          swagger_doc = JSON.parse(subject.read)

          expect(swagger_doc.keys)
            .to eql(["basePath", "consumes", "definitions", "info", "paths",
                     "produces", "schemes", "swagger", "tags", "host"])

          expect(swagger_doc["definitions"].keys)
            .to eql(["b", "c", "d", "emptyObject", "genericLink"])
        end
      end
    end

    context 'doodoo' do
      before do
        allow(File).to receive(:read).and_return(swagger_doc)
      end

      context 'when a host name is defined in the swagger doc' do
        let(:swagger_doc) { <<-DOC.strip_heredoc
          swagger: '2.0'
          info:
            version: '1'
            title: Westfield Deal Service
          host: "some-custom-host-defined-in-swagger-doc"
          DOC
        }

        it 'is expected to use the host name provided in the swagger doc' do
          swagger_doc_json = JSON.parse(subject.read)

          expect(swagger_doc_json["host"]).to eql('some-custom-host-defined-in-swagger-doc')
        end
      end

      context 'when a host name is not defined in the swagger doc' do
        let(:swagger_doc) { <<-DOC.strip_heredoc
          swagger: '2.0'
          info:
            version: '1'
            title: Westfield Deal Service
          DOC
        }

        it 'is expected to return the requesting host name' do
          swagger_doc_json = JSON.parse(subject.read)
          expect(swagger_doc_json["host"]).to eql(request.host_with_port)
        end
      end
    end
  end

  describe '#swagger_api_host' do
    subject { super().send(:swagger_api_host) }

    context 'when the API_HOST_URL environment variable is set' do
      before do
        stub_const('ENV', {'API_HOST_URL' => custom_api_host})
      end

      it { is_expected.to eql(custom_api_host) }
    end

    context 'in any environment' do
      it { is_expected.to eql(request.host_with_port) }
    end
  end
end
