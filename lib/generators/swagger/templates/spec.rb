RSpec.describe 'the API', type: :apivore, order: :defined do
  subject { Apivore::SwaggerChecker.instance_for(WestfieldSwagger.path_for(<%= WestfieldSwagger.api_version %>)) }

  context 'has valid paths' do
    # Tests go here

    # Example:
    let(:params) { { "example_id" => 1 } }
    specify do
      expect(subject).to validate(
        :get, '/examples/{example_id}.json', 200, params
      )
    end

  end

  context 'and' do
    it 'tests all documented routes' do
      expect(subject).to validate_all_paths
    end
  end
end
