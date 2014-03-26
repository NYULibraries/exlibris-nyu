module Exlibris
  module Primo
    module Source
      module Coverage
        class Note
          attr_reader :value

          def initialize(value)
            @value = value
          end

          def to_s
            "Note: #{value}"
          end
        end
      end
    end
  end
end
