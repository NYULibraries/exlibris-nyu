module Exlibris
  module Primo
    module Source
      module Coverage
        class TextualHolding
          attr_reader :collection, :value

          def initialize(collection, value)
            @collection = collection
            @value = value
          end

          def to_s
            "Available in #{collection}: #{value}"
          end
        end
      end
    end
  end
end
