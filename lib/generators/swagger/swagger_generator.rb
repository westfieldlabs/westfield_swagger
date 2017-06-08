class SwaggerGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def copy_example_yml
    copy_file 'example.yml', "lib/swagger/#{WestfieldSwagger.api_version}.yml"
    copy_file 'spec.rb', 'spec/requests/swagger_spec.rb'
    route "mount WestfieldSwagger::Engine, at: '/'\n"
  end
end
