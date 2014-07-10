module Exlibris
  module Nyu
    module Aleph
      class SubLibraryFinder

        attr_reader :sub_library_code

        def initialize(sub_library_code)
          @sub_library_code = sub_library_code
        end

        def sub_library
          @sub_library ||= sub_libraries.find do |sub_library|
            sub_library.code == sub_library_code
          end
        end

        private
        def tables_manager
          @tables_manager ||= Exlibris::Aleph::TablesManager.instance
        end

        def sub_libraries
          @sub_libraries ||= tables_manager.sub_libraries
        end
      end
    end
  end
end
