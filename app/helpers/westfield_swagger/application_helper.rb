module WestfieldSwagger
  module ApplicationHelper

    def mounted_path path
      "/swagger#{ path }"
    end

  end
end
