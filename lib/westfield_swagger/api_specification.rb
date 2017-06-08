require_relative 'utilities'
include WestfieldSwagger::Utilities

class WestfieldSwagger::ApiSpecification
  class SpecificationMissing < StandardError; end
  class SpecificationParseError < StandardError; end

  def initialize(version, context, request, env_prefix = "")
    @version = version
    @context = context
    @request = request
    @env_version = "#{env_prefix}#{version}"
  end

  attr_reader :version, :env_version

  def read
    read_json || read_directory || read_yaml || swagger_specifications_not_found
  end

  def swagger_api_host
    return ENV['API_HOST_URL'] if ENV['API_HOST_URL'].present?

    # Do not specify the port if it's standard HTTP/HTTPS
    return request.host if [80, 443].include?(request.port)

    request.host_with_port
  end

  private

  attr_reader :request

  def most_recent_file_modification_date
    individual_swagger_files.map {|file| File.mtime(file) }.sort.last
  end

  def last_modified_at
    return most_recent_file_modification_date.utc.iso8601 if swagger_directory_exists?

    path_to_swagger_file = nil

    if swagger_file_exists?(extension: 'json')
      path_to_swagger_file = file_path(extension: 'json')
    elsif swagger_file_exists?(extension: 'yml')
      path_to_swagger_file = file_path(extension: 'yml')
    end

    File.mtime(path_to_swagger_file).utc.iso8601 if path_to_swagger_file
  end

  def add_info_block(doc)
    doc['info']['x-last_modified_at'] = last_modified_at
    doc['info']['license'] = { name: 'Apache 2 License',
                               url: 'http://www.apache.org/licenses/LICENSE-2.0' }
    doc['info']['contact'] = { name: 'Westfield Support',
                               url: 'http://www.westfieldstatus.com',
                               email: 'help@westfieldsupport.com' }
  end

  def convert_to_json(swagger_document:)
    swagger_document['host'] ||= swagger_api_host
    add_info_block(swagger_document)
    JSON.pretty_generate(swagger_document)
  rescue StandardError => e
    message = "Unable to parse API specification for version '#{version}'"
    if Rails.env.development? || Rails.env.test?
      raise $!, "#{self.class.parent_name}: #{message} Error: #{e}", $!.backtrace
    end
    fail SpecificationParseError, message
  end

  def swagger_specifications_not_found
    fail SpecificationMissing, "API Specification for version '#{version}' does not exist."
  end

  def read_json
    File.read(file_path(extension: 'json')) if swagger_file_exists?(extension: 'json')
  end

  def individual_swagger_files
    Dir.glob(directory_path(wildcard: '**/*.yml'))
  end

  def read_directory
    convert_to_json(swagger_document: combined_swagger_files) if swagger_directory_exists?
  end

  def read_yaml
    if swagger_file_exists?(extension: 'yml')
      convert_to_json(swagger_document: read_from_file(file_path(extension: 'yml')))
    end
  end

  def swagger_file_exists?(extension:)
    File.file?(file_path(extension: extension))
  end

  def file_path(extension:)
    Rails.root.join('lib', 'swagger', "#{env_version}.#{extension}")
  end

  def swagger_directory_exists?
    File.directory?(directory_path)
  end

  def directory_path(wildcard: '')
    Rails.root.join('lib', 'swagger', version, wildcard)
  end

  def read_from_file(filepath)
    YAML.load(ERB.new(File.read(filepath)).result(@context))
  end

  def combined_swagger_files
    data = individual_swagger_files.map do |filepath|
      read_from_file(filepath)
    end
    unsorted_data = data.inject({}) { |hash, item| hash.deep_merge(item) }
    deeply_sort_hash(unsorted_data)
  end

end
