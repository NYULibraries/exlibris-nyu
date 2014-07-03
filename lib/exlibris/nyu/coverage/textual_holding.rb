module Exlibris
  module Nyu
    module Coverage
      class TextualHolding

        def self.from_bib_866(collection, bib_866)
          value = ""
          volumes = bib_866['j']
          years = bib_866['k']
          value += "VOLUMES: #{volumes}" unless volumes.nil? and volumes.nil?
          value += " (YEARS: #{years})" unless years.nil? or years.empty?
          self.new(collection, value) unless value.empty?
        end

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
