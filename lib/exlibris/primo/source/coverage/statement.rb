module Exlibris
  module Primo
    module Source
      module Coverage
        class Statement
          attr_reader :textual_holdings, :notes
          def initialize(textual_holdings, notes=[])
            textual_holdings ||= []
            notes ||= []
            unless(textual_holdings.is_a?(Array))
              raise ArgumentError.new("textual_holdings is not an array")
            end
            unless(notes.is_a?(Array))
              raise ArgumentError.new("notes is not an array")
            end
            if textual_holdings.empty? && notes.empty?
              raise ArgumentError.new("textual_holdings and notes can't both be empty")
            end
            @textual_holdings = textual_holdings
            @notes = notes
          end

          def to_a
            @statement_array ||= textual_holdings.map(&:to_s) + notes.map(&:to_s)
          end
        end
      end
    end
  end
end
