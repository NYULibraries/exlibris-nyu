module Exlibris
  module Primo
    module Source
      class CoverageStatement
        attr_reader :adm_library, :sub_library, :collection, :textual_holdings, :notes
        def initialize(attributes)
          unless attributes.is_a?(Hash)
            raise ArgumentError.new("Argument is not a Hash")
          end
          @adm_library = attributes.fetch(:adm_library, nil)
          if adm_library.nil?
            raise ArgumentError.new("No :adm_library in given attributes")
          end
          @sub_library = attributes.fetch(:sub_library, nil)
          if sub_library.nil?
            raise ArgumentError.new("No :sub_library in given attributes")
          end
          @collection = attributes.fetch(:collection, nil)
          if collection.nil?
            raise ArgumentError.new("No :collection in given attributes")
          end
          @textual_holdings = attributes.fetch(:textual_holdings, nil)
          @notes = attributes.fetch(:notes, nil)
          if textual_holdings.nil? && notes.nil?
            raise ArgumentError.new("No :textual_holdings or :notes in given attributes;" +
              "You must include at least one of them")
          end
        end
      end
    end
  end
end
