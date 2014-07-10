module Exlibris
  module Nyu
    module Aleph
      class CollectionFinder

        attr_reader :sub_library_code, :collection_code_or_display

        def initialize(sub_library_code, collection_code_or_display)
          @sub_library_code = sub_library_code
          @collection_code_or_display = collection_code_or_display
        end

        def collection
          @collection ||= begin
            unless collections.nil?
              collections.find do |collection|
                sub_library.eql?(collection.sub_library) &&
                collection_code_or_display_eql?(collection)
              end
            end
          end
        end

        private
        def collection_code_or_display_eql?(collection)
          (collection_code_or_display.eql?(collection.code) || 
            collection_code_or_display.eql?(collection.display))
        end

        def sub_library
          @sub_library ||= sub_library_finder.sub_library
        end

        def sub_library_finder
          @sub_library_finder ||= SubLibraryFinder.new(sub_library_code)
        end

        def tables_manager
          @tables_manager ||= Exlibris::Aleph::TablesManager.instance
        end

        def admin_library
          @admin_library ||= sub_library.admin_library unless sub_library.nil?
        end

        def collections
          @collections ||= tables_manager.collections[admin_library]
        end
      end
    end
  end
end
