module WestfieldSwagger
  class SwaggerController < WestfieldSwagger::ApplicationController
    rescue_from ApiSpecification::SpecificationParseError, with: :specification_parse_error
    rescue_from ApiSpecification::SpecificationMissing, with: :specification_missing

    ENV_PREFIX = %w(uat production).include?(Rails.env) ? "#{Rails.env}_" : ''

    def index
      if params[:service]
        # Access service swagger
        env_prefix = ''
        @service = "#{params[:service]}/"
      else
        # Access roll-up swagger
        env_prefix = ENV_PREFIX
        @service = ""
      end

      @spec = WestfieldSwagger::ApiSpecification.new(params[:version], binding, request, env_prefix)

      respond_to do |format|
        format.html
        format.json { render json: @spec.read }
        format.all {
          render text: "Format '#{params[:format]}' not supported", status: 404
        }
      end
    end

    def specification_parse_error(exception)
      data = { error: exception.message }
      render json: data, status: 500
    end

    def specification_missing(exception)
      data = { error: exception.message }
      render json: data, status: 404
    end

  end
end
