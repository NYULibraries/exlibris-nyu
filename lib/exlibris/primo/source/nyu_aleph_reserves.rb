module Exlibris
  module Primo
    module Source
      require 'exlibris-aleph'
      ##
      # NyuAlephReserves is an Exlibris::Primo::Source::NyuAleph that
      # overrides availability and collection to provide specific
      # functionality for reserves.
      #
      class NyuAlephReserves < Exlibris::Primo::Source::NyuAleph

        # Overrides NyuAleph#status
        def status
          if from_aleph?
            Exlibris::Nyu::Aleph::ReservesStatus.new(super, item_status)
          else
            super
          end
        end

        # Override NyuAleph#collection
        def collection
          (from_aleph? && sub_library.code == 'BRES') ? '' : super
        end

        protected
        # For the most part, always expand Reserves items
        def expanding?
          (from_aleph? || expanded_holdings.any?)
        end
      end
    end
  end
end
