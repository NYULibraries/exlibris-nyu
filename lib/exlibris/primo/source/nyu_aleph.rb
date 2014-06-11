module Exlibris
  module Primo
    module Source
      require 'exlibris-aleph'
      ##
      # NyuAleph is an Exlibris::Primo::Holding that expands Primo holdings
      # based on the Aleph items return from the Aleph REST APIs.
      # It stores metadata from these items in the source data attribute
      # that can be used by custom controllers to extend patron services,
      # including request and paging functionality.
      # NyuAleph also provides coverage metadata based on bib and holdings
      # information from the Aleph record and holdings REST APIs.
      #
      class NyuAleph < Exlibris::Primo::Source::Aleph

        attr_reader :aleph_item

        # Overwrites Exlibris::Primo::Holding
        def initialize(attributes={})
          @aleph_item = attributes[:aleph_item]
          super(attributes)
        end

        # Overrides Exlibris::Primo::Holding
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
          !aleph_item.nil?
        end
        alias_method :expanded?, :from_aleph?
        alias_method :from_aleph, :from_aleph?

        # Overrides Exlibris::Primo::Source::Aleph#institution_code
        # based on the source config settings
        # 
        # This is necessary since we are expanding from a source that may
        # not have the same institution
        def institution_code
          (from_aleph?) ? aleph_item.institution : super
        end

        # Overrides Exlibris::Primo::Source::Aleph#sub_library_code to return
        # based on the Aleph item
        def sub_library_code
          (from_aleph?) ? sub_library.code : (super || library_code)
        end

        def library
          (sub_library || super)
        end

        # Overrides Exlibris::Primo::Source::Aleph#sub_library to return
        # based on the Aleph item
        def sub_library
          (from_aleph?) ? aleph_item.sub_library : translator.sub_library
        end

        # Overrides Exlibris::Primo::Source::Aleph#collection to return
        # based on the Aleph item
        def collection
          (from_aleph?) ? aleph_item.collection : super
        end

        # Overrides Exlibris::Primo::Source::Aleph#call_number to return
        # based on the Aleph item
        def call_number
          (from_aleph?) ? aleph_item.call_number : super
        end

        # Overrides Exlibris::Primo::Holding#status to return
        # based on the Aleph item
        def status
          (from_aleph?) ? aleph_item.status : super
        end

        # The OPAC note if it's from Aleph
        def opac_note
          (from_aleph?) ? aleph_item.opac_note : nil
        end

        # The number of requests on the item
        # 0 if it's not from Aleph
        def number_of_requests
          (from_aleph?) ? aleph_item.queue.number_of_requests : 0
        end

        # It's only requestable if we're expanding and it's
        # from Aleph and then defer to the Aleph item
        def requestability
          @requestability ||= begin
            unless expanding? && from_aleph?
              Exlibris::Nyu::Aleph::Requestability::NO
            else
              aleph_item.requestability
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
            aleph_item = Exlibris::Nyu::Aleph::Item.new(item)
            source_data = {item_id: aleph_item.id}
            self.class.new({holding: self, aleph_item: aleph_item, source_data: source_data})
          end
        end

        def translator
          @translator ||= Exlibris::Nyu::Aleph::Translator.new(sub_library_code)
        end

        # Get Aleph record
        def record
          @record ||= Exlibris::Aleph::Record.new(ils_api_id)
        end

        def record_metadata
          @record_metadata ||= record.metadata
        end

        # Returns an empty array if we get an error, e.g. Aleph is down
        def holdings
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
            @bib_coverage ||=
              Exlibris::Nyu::Coverage::Statement.from_record_metadata(sub_library, record_metadata)
          end
        end

        # Coverage::Statement from Aleph holdings
        def holdings_coverage
          if @bib_coverage.nil?
            @holdings_coverage ||= 
              Exlibris::Nyu::Coverage::Statement.from_holdings(sub_library, holdings)
          end
        end
      end
    end
  end
end
