module Exlibris
  module Primo
    module Source
      class NyuAleph
        class CallNumber
          attr_reader :classification, :description
          def initialize(classification, description)
            @classification = de_nbsp(de_marcify(classification))
            @description = de_nbsp(description)
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
end
