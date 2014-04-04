module Exlibris
  module Primo
    module Source
      require 'exlibris-aleph'
      ##
      # NyuAleph is an Exlibris::Primo::Source::Aleph that expands Primo holdings
      # based on the Aleph items return from the Aleph REST APIs.
      # It stores metadata from these items in the source data attribute
      # that can be used by custom controllers to extend patron services,
      # including request and paging functionality.
      # NyuAleph also provides coverage metadata based on bib and holdings
      # information from the Aleph bib and holdings REST APIs.
      #
      class NyuAleph < Exlibris::Primo::Source::Aleph

        # Overwrites Exlibris::Primo::Source::Aleph#new
        def initialize(attributes={})
          @aleph_holding = attributes[:aleph_holding]
          super(attributes)
        end

        # Overrides Exlibris::Primo::Source::Aleph#expand
        def expand
          (expanding?) ? expanded_holdings : super
        end

        # Overrides Exlibris::Primo::Holding#==
        # Only compare to other Primo Holding
        def ==(other_nyu_aleph)
          if other_nyu_aleph.is_a?(Exlibris::Primo::Holding) && expanding?
            source_id == other_nyu_aleph.source_id &&
              source_record_id == other_nyu_aleph.source_record_id
          else
            super
          end
        end
        alias :eql? :==

        # Is this Holding from Aleph?
        def from_aleph?
          !@aleph_holding.nil?
        end
        alias_method :expanded?, :from_aleph?
        alias_method :from_aleph, :from_aleph?

        # Overrides Exlibris::Primo::Source::Holding#institution_code
        # based on the source config settings
        # 
        # This is necessary since we are expanding from a source that may
        # not have the same institution
        def institution_code
          (from_aleph?) ? @aleph_holding.institution : super
        end

        # Overrides Exlibris::Primo::Source::Aleph#sub_library based
        # on the Aleph holding
        #   library -> sub_library -> super -> library
        def sub_library
          (from_aleph?) ? @aleph_holding.sub_library : super
        end

        # Overrides Exlibris::Primo::Source::Aleph#sub_library based
        # on the expanded source data
        def sub_library_code
          (from_aleph?) ? source_data[:sub_library_code] : (super || library_code)
        end

        # Overrides Exlibris::Primo::Holding#library to return
        # based on the Aleph holding
        def library
          (from_aleph?) ? @aleph_holding.sub_library : super
        end

        # Overrides Exlibris::Primo::Holding#collection to return
        # based on the Aleph holding
        def collection
          (from_aleph?) ? @aleph_holding.collection : super
        end

        # Overrides Exlibris::Primo::Holding#call_number to return
        # based on the Aleph holding
        def call_number
          (from_aleph?) ? @aleph_holding.call_number : super
        end

        # Overrides Exlibris::Primo::Holding#availability_status_code
        def availability_status_code
          (from_aleph?) ? @aleph_holding.status : super
        end
        alias :status_code :availability_status_code

        # Overrides Exlibris::Primo::Holding#availability_status
        def availability_status
          (from_aleph?) ? @aleph_holding.status_display : super
        end
        alias :availability :availability_status
        alias :status :availability_status

        # It's only requestable if we're expanding the holdings
        # and then defer to the holding
        def requestability
          @requestability ||= begin
            unless expanding?
              Exlibris::Nyu::Holding::Requestability::NO
            else
              @aleph_holding.requestability
            end
          end
        end

        # Overrides Exlibris::Primo::Holding#coverage to return
        # based on Aleph bib and holdings coverage
        # Only get coverage for journals
        def coverage
          return @coverage unless @coverage.nil? or @coverage.empty?
          @coverage = (journal?) ? (holdings_coverage || bib_coverage).to_a : []
        end

        private
        # Logic to determine whether we're expanding this holding
        # Only expand if not a journal and we've already been to Aleph
        # or we have expanded holdings from Aleph (Aleph could be down) or
        def expanding?
          @expanding ||= (!journal? && (from_aleph? || expanded_holdings.any?))
        end

        # Is this a journal
        def journal?
          (display_type && display_type.upcase == "JOURNAL")
        end

        # Get expanded holdings based on Aleph items.
        def expanded_holdings
          @expanded_holdings ||= items.map do |item|
            aleph_holding = Exlibris::Nyu::Holding.from_aleph(item)
            source_data = {
              original_source_id: original_source_id,
              source_record_id: source_record_id,
              adm_library: aleph_holding.extras[:adm_library],
              sub_library_code: aleph_holding.extras[:sub_library_code],
              collection_code: aleph_holding.extras[:collection_code],
              item_status_code: aleph_holding.extras[:item_status_code],
              item_process_status_code: aleph_holding.extras[:item_process_status_code],
              item_id: aleph_holding.extras[:item_id],
              item_status: aleph_holding.extras[:item_status]
            }
            self.class.new({holding: self, aleph_holding: aleph_holding, source_data: source_data})
          end
        end

        # Get Aleph record
        def record
          @record ||=
            Exlibris::Aleph::Record.new(bib_library: original_source_id, record_id: source_record_id)
        end

        # Returns nil if we get an error, e.g. Aleph is down
        def marc_bib
          @marc_bib ||= record.bib
        rescue
          nil
        end

        # Returns an empty array if we get an error, e.g. Aleph is down
        def marc_holdings
          @marc_holdings ||= record.holdings
        rescue
          []
        end

        # Returns an empty array if we get an error, e.g. Aleph is down
        def items
          @items ||= record.items
        rescue
          []
        end

        # Coverage::Statement from Aleph bib
        def bib_coverage
          if @holdings_coverage.nil?
            @bib_coverage ||= Exlibris::Nyu::Coverage::Statement.from_marc_bib(sub_library_code, marc_bib)
          end
        end

        # Coverage::Statement from Aleph holdings
        def holdings_coverage
          if @bib_coverage.nil?
            @holdings_coverage ||= 
              Exlibris::Nyu::Coverage::Statement.from_marc_holdings(sub_library_code, marc_holdings)
          end
        end
      end
    end
  end
end
