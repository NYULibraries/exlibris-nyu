module Exlibris
  module Nyu
    class Holding
      class SubLibraryInstitution
        attr_reader :sub_library

        def initialize(sub_library)
          @sub_library = sub_library
        end

        def institution
          @institution ||= config[sub_library]
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
