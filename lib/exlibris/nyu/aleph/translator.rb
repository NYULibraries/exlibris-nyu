module Exlibris
  module Nyu
    module Aleph
      class Translator

        attr_reader :sub_library_code, :collection_code

        def initialize(sub_library_code, collection_code = nil)
          @sub_library_code = sub_library_code
          @collection_code = collection_code
        end

        def admin_library
          @admin_library ||= sub_library.admin_library unless sub_library.nil?
        end

        def sub_library
          @sub_library ||= sub_libraries.find do |sub_library|
            sub_library.code == sub_library_code
          end
        end

        def collection
          @collection ||= begin
            unless collections.nil?
              collections.find do |collection|
                collection.sub_library == sub_library &&
                  collection.code == collection_code
              end
            end
          end
        end

        private
        def tables_manager
          @tables_manager ||= Exlibris::Aleph::TablesManager.instance
        end

        def sub_libraries
          @sub_libraries ||= tables_manager.sub_libraries
        end

        def collections
          @collections ||= tables_manager.collections[admin_library]
        end
      end
    end
  end
end
