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
        ILLIAD_URL = "http://ill.library.nyu.edu"

        # Rename the old sub library code method
        alias_method :aleph_sub_library_code, :sub_library_code

        attr_accessor :adm_library_code, :sub_library_code, :collection_code,
          :item_status_code, :item_process_status_code, :item_status,
          :item_process_status, :queue

        attr_reader :circulation_status
        private :circulation_status

        # Overwrites Exlibris::Primo::Source::Aleph#new
        def initialize(attributes={})
          super(attributes)
          @circulation_status = Exlibris::Nyu::Holding::CirculationStatus.new(attributes[:circulation_status])
          @source_data[:sub_library] = sub_library
          @source_data[:illiad_url] = ILLIAD_URL
          @source_data[:aleph_rest_url] = aleph_rest_url
        end

        # Overrides Exlibris::Primo::Source::Aleph#expand
        def expand
          (expanding?) ? expanded_holdings : super
        end

        # Overrides Exlibris::Primo::Holding#==
        # Only compare to other Primo Holding
        def ==(other_nyu_aleph)
          return super unless other_nyu_aleph.is_a? Exlibris::Primo::Holding
          if expanding?
            ( source_id == other_nyu_aleph.source_id &&
              source_record_id == other_nyu_aleph.source_record_id)
          else
            super
          end
        end
        alias :eql? :==

        # Is this Holding from Aleph?
        def from_aleph?
          @from_aleph ||= !!source_data[:from_aleph]
        end
        alias_method :expanded?, :from_aleph?
        alias_method :from_aleph, :from_aleph?

        # Overrides Exlibris::Primo::Source::Holding#institution_code
        #
        # Can't use "or equal", i.e.
        #
        #   @institution_code ||= ...
        #
        # b/c @institution_code is set at instantiation time
        # and we're trying to override it with the source config settings
        # 
        # TODO: Figure out if this is even necessary?
        def institution_code
          @institution_code =
            (nyu_aleph_config.institutions[sub_library_code] || super)
        end

        # Overrides Exlibris::Primo::Source::Aleph#sub_library based
        # on the Aleph table helper
        # Can't call super, i.e.
        #
        #   @sub_library ||= (... || super)
        #
        # b/c an infinite loop is then possible, since
        # NyuAleph#library calls this method (i.e. NyuAleph#sub_library)
        # and super (i.e. Aleph#sub_library) would call NyuAleph#library
        #
        # Infinite loop:
        # 
        #   library -> sub_library -> super -> library
        def sub_library
          @sub_library ||= (translator.sub_library || sub_library_code)
        end

        # Overrides Exlibris::Primo::Holding#library to return sub_library
        def library
          @library ||= (sub_library || super)
        end

        # Overrides Exlibris::Primo::Holding#collection to return
        # based on Aleph table helper
        #
        # Can't use "or equal", i.e.
        #
        #   @collection ||= ...
        #
        # b/c @collection is set at instantiation time
        # and we're trying to override it with the Aleph text
        def collection
          @collection = (translator.collection || super)
        end

        # Overrides Exlibris::Primo::Holding#availability_status_code
        def availability_status_code
          (nyu_aleph_availability_status.code || super)
        end
        alias :status_code :availability_status_code

        # Overrides Exlibris::Primo::Holding#availability_status
        def availability_status
          (nyu_aleph_availability_status.value || translator.item_status || super)
        end
        alias :availability :availability_status
        alias :status :availability_status

        # The "requestability" of the item, i.e. under what
        # circumstances is the item requestable
        # It's only requestable if we're expanding the holdings
        # Some circulations statuses are non requestable:
        #   - Reshelving
        # If we're considering requestabilty, let a requestability
        # object do the work
        def requestability
          @requestability ||= begin
            if (!expanding? || circulation_status.reshelving?)
              Exlibris::Nyu::Holding::Requestability::NO
            else
              Exlibris::Nyu::Holding::Requestability.new(translator.item_permissions).value
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
        def nyu_aleph_availability_status
          @nyu_aleph_availability_status ||= Exlibris::Nyu::Holding::AvailabilityStatus.new(circulation_status)
        end

        def translator
          @translator ||= Exlibris::Nyu::Holding::Translator.new(
            adm_library_code: adm_library_code,
            sub_library_code: sub_library_code,
            collection_code: collection_code,
            item_status_code: item_status_code,
            item_process_status_code: item_process_status_code)
        end

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
            source_data = { from_aleph: true, source_record_id: source_record_id }
            source_data.merge!(Exlibris::Nyu::Holding::Item.new(item).to_h)
            self.class.new({holding: self, source_data: source_data}.merge(source_data))
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

        # Library for matching the coverage
        def coverage_library
          @coverage_libary ||= (aleph_sub_library_code || library_code)
        end

        # Coverage::Statement from Aleph bib
        def bib_coverage
          if @holdings_coverage.nil?
            @bib_coverage ||= Exlibris::Nyu::Coverage::Statement.from_marc_bib(coverage_library, marc_bib)
          end
        end

        # Coverage::Statement from Aleph holdings
        def holdings_coverage
          if @bib_coverage.nil?
            @holdings_coverage ||= 
              Exlibris::Nyu::Coverage::Statement.from_marc_holdings(coverage_library, marc_holdings)
          end
        end

        def nyu_aleph_config
          @nyu_aleph_config ||= Exlibris::Nyu::Holding::Config.new(source_config)
        end
      end
    end
  end
end
