module Exlibris
  module Nyu
    module Holding
      class Config
        attr_reader :source
        private :source

        def initialize(source)
          @source = source
        end

        def institutions
          @institutions ||= source["institution_codes"]
        end

        def statuses
          @institutions ||= source["statuses"]
        end
      end
    end
  end
end
