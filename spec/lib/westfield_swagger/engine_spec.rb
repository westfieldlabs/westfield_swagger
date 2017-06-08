require 'spec_helper'

RSpec.describe WestfieldSwagger do
  describe '.path_for' do
    context 'v1 swagger path' do
      specify { expect(subject.path_for(1)).to eql "/swagger/1.json" }
    end

    context 'v2 swagger path' do
      specify { expect(subject.path_for(2)).to eql "/swagger/2.json" }
    end

    context 'used with api_version' do
      before  { stub_const('ENV', {'SWAGGER_API_VERSION' => '2'}) }
      specify { expect(subject.path_for(WestfieldSwagger.api_version)).to eql "/swagger/2.json" }
    end
  end
end
