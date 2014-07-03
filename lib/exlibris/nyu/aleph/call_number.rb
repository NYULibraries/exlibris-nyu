module Exlibris
  module Nyu
    module Aleph
      class CallNumber
        attr_reader :classification, :description
        def initialize(call_number)
          unless(call_number.is_a?(Exlibris::Aleph::Item::CallNumber))
            raise ArgumentError.new("Expecting #{call_number} to be an Exlibris::Aleph::Item::CallNumber")
          end
          @classification = de_nbsp(de_marcify(call_number.classification))
          @description = de_nbsp(call_number.description)
        end

        def to_s
          @value ||= begin
            if classification && description
              "(#{classification} #{description})"
            elsif description
              "(#{description})"
            elsif classification
              "(#{classification})"
            else
              ""
            end
          end
        end

        private
        def de_marcify(marcified)
          marcified.gsub(/\$\$h/, "").gsub(/\$\$i/, " ") if marcified
        end

        def de_nbsp(nbspied)
          nbspied.gsub("&nbsp;", " ") if nbspied
        end
      end
    end
  end
end
