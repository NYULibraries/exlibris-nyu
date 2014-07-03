module Exlibris
  module Nyu
    module Aleph
      class SubLibraryInstitution
        attr_reader :sub_library

        def initialize(sub_library)
          unless(sub_library.is_a?(Exlibris::Aleph::SubLibrary))
            raise ArgumentError.new("Expecting #{sub_library} to be an Exlibris::Aleph::SubLibrary")
          end
          @sub_library = sub_library
        end

        def institution
          @institution ||= config[sub_library.code]
        end

        private
        def config_file
          File.expand_path('../../../../../config/sub_library_institutions.yml', __FILE__)
        end

        def config
          YAML.load_file(config_file)
        end
      end
    end
  end
end
