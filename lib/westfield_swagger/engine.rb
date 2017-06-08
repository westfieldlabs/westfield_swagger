module WestfieldSwagger
  class Engine < ::Rails::Engine
    isolate_namespace WestfieldSwagger

    config.generators do |g|
      g.test_framework :rspec
      g.assets false
      g.helper false
    end

    initializer 'static assets' do |app|
      app.middleware.use(
        ::ActionDispatch::Static,
        "#{root}/public"
      )
    end
  end

  DEFAULT_API_VERSION = '1'

  def self.api_version
    if ENV.include? 'SWAGGER_API_VERSION'
      ENV['SWAGGER_API_VERSION'].to_s
    elsif Rails.application.config.respond_to? :api_version
      Rails.application.config.api_version.to_s
    else
      DEFAULT_API_VERSION
    end
  end

  def self.path_for(version)
    "/swagger/#{version}.json"
  end
end
