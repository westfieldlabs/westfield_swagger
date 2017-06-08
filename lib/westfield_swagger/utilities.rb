module WestfieldSwagger::Utilities
  # taken from http://stackoverflow.com/a/13368706
  def deeply_sort_hash(object)
    return object unless object.is_a?(Hash)
    hash = ActiveSupport::OrderedHash.new
    object.each { |k, v| hash[k] = deeply_sort_hash(v) }
    sorted = hash.sort { |a, b| a[0].to_s <=> b[0].to_s }
    hash.class[sorted]
  end
end
