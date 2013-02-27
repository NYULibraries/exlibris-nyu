module Exlibris
  module Primo
    module Source
      require 'exlibris-aleph'
      require 'nokogiri'
      ##
      # NyuAlephReserves is an Exlibris::Primo::Source::NyuAleph that
      # overrides availability and collection to provide specific
      # functionality for reserves.
      #
      class NyuAlephReserves < Exlibris::Primo::Source::NyuAleph

        # Overrides NyuAleph#availability_status
        def availability_status
          unless defined? @reserves_availability_status
            @reserves_availability_status = super.dup
            @reserves_availability_status << " - #{item_status}" if @reserves_availability_status.eql? "Available"
          end
          @reserves_availability_status
        end
        alias :availability :availability_status
        alias :status :availability_status

        # Override NyuAleph#collection  
        def collection
          (sub_library_code.eql? "BRES") ? "" : super
        end
      end
    end
  end
end