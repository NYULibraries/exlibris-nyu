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
        # Constants for 'requestability'.
        RequestableYes = 'yes' # Yes, obviously
        RequestableDeferred = 'deferred' # Defer the requestability decision
        RequestableNo = 'no' # No
        RequestableUnknown = 'unknown' # Unknown, but essentially no

        alias_method :aleph_sub_library_code, :sub_library_code

        attr_accessor :adm_library_code, :sub_library_code, :collection_code,
          :item_status_code, :item_process_status_code, :circulation_status,
            :item_status, :item_process_status, :queue

        # Overwrites Exlibris::Primo::Source::Aleph#new
        def initialize(attributes={})
          super(attributes)
          @source_data[:sub_library] = sub_library
          @source_data[:illiad_url] = illiad_url
          @source_data[:aleph_rest_url] = aleph_rest_url
        end

        # Overrides Exlibris::Primo::Holding#availability_status_code
        def availability_status_code
          # First check if the item is recalled.
          return @availability_status_code = "recalled" if recalled?
          # Then check if the item is checked out
          return @availability_status_code = "checked_out" if checked_out?
          # Then check if it's requested
          return @availability_status_code = "requested" if requested? or recalled?
          # Then check based on circulation status
          return @availability_status_code = circulation_status_code.dup unless circulation_status_code.nil?
          # Then check based on item_web_text
          return @availability_status_code = "overridden_by_nyu_aleph" unless item_web_text.nil?
          # Otherwise super
          super
        end
        alias :status_code :availability_status_code

        # Overrides Exlibris::Primo::Holding#availability_status
        def availability_status
          # First check if the item is recalled.
          return @availability_status = "Due: #{recalled_due_date}" if recalled?
          # Then check if the item is checked out
          return @availability_status = "Due: #{circulation_status}" if checked_out?
          # Then check if we're reshelving
          return @availability_status = "Reshelving" if reshelving?
          # Then check if it's requested
          return @availability_status = circulation_status if requested?
          # Then check based on item_web_text if we're not dealing with a circulation status
          return @availability_status = item_web_text if circulation_status_code.nil? and item_web_text
          # Otherwise super
          super
        end
        alias :availability :availability_status
        alias :status :availability_status

        # Overrides Exlibris::Primo::Source::Aleph#expand
        def expand
          (expanding?) ? expanded_holdings : super
        end

        # Overrides Exlibris::Primo::Holding#==
        def ==(other_nyu_aleph)
          # Only compare to other Primo Holdings
          return super unless other_nyu_aleph.is_a? Exlibris::Primo::Holding
          (expanding?) ?
            (source_id == other_nyu_aleph.source_id and source_record_id == other_nyu_aleph.source_record_id) : super
        end
        alias :eql? :==

        # Does this holding request link support AJAX requests?
        # Only if we're already expanded
        # TODO: this is tightly couple to the Umlaut application
        # and should be abstracted out, or something :)
        def ajax?
          expanded?
        end
        alias :request_link_supports_ajax_call? :ajax?
        alias :request_link_supports_ajax_call :ajax?

        # Overrides Exlibris::Primo::Source::Aleph#institution_code
        def institution_code
          @insitution_code = ((not source_config["institution_codes"].nil?) and source_config["institution_codes"].has_key?(sub_library_code)) ?
            source_config["institution_codes"][sub_library_code] : super
        end

        # Overrides Exlibris::Primo::Source::Aleph#sub_library based
        # on the Aleph table helper
        def sub_library
          @sub_library ||= aleph_helper.sub_library_text(sub_library_code)
        end

        # Overrides Exlibris::Primo::Holding#library to return sub_library
        def library
          (sub_library.nil?) ? super : sub_library
        end

        # Overrides Exlibris::Primo::Holding#collection to return
        # based on Aleph table helper
        def collection
          (adm_library_code.nil? or sub_library_code.nil? or collection_code.nil?) ?
              super : nyu_aleph_collection
        end

        # The "requestability" of the holding, i.e. under what
        # circumstances is the holding requestable
        def requestability
          # It's only requestable if we're expanding the holdings
          return RequestableNo unless expanding?
          # Some circulations statuses are non requestable.
          # Non-Requestable circulation statuses include:
          #   - Reshelving
          return RequestableNo if reshelving?
          # Also if we don't have request permissions, we can't request.
          return RequestableNo if request_permissions.nil?
          # Check holding permissions
          # If the holding has "C" as its hold request permission, it is requestable.
          # Also if it has "Y" in its photocopy request (indicating ILL), it is requestable.
          return RequestableYes if (request_permissions[:hold_request].eql?("C") or 
            request_permissions[:photocopy_request].eql?("Y"))
          # If the holding has "Y" as it's hold request permission some user can request
          # so we must defer the decision.
          return RequestableDeferred if request_permissions[:hold_request].eql?("Y")
          return RequestableNo
        end

        # The collection based on the Aleph table helper
        def nyu_aleph_collection
          @nyu_aleph_collection ||= aleph_helper.collection_text(
            :adm_library_code => adm_library_code.downcase,
              :sub_library_code => sub_library_code, :collection_code => collection_code)
        end
        private :nyu_aleph_collection

        # Request permissions for this holding based on 
        # the Aleph table helper
        def request_permissions
          @request_permissions ||= (adm_library_code.nil?) ? {} :
            aleph_helper.item_permissions(:adm_library_code => adm_library_code.downcase, 
              :sub_library_code => sub_library_code, :item_status_code => item_status_code, 
                :item_process_status_code => item_process_status_code) 
        end
        private :request_permissions

        # Is this holding requested?
        def requested?
          /Requested/=~ circulation_status
        end
        private :requested?

        # Is this holding recalled?
        def recalled?
          /Recalled/=~ circulation_status
        end
        private :recalled?

        # Are we reshelving this item?
        def reshelving?
          /Reshelving/=~ circulation_status
        end
        private :reshelving?

        # The number of requests made for this holding
        def request_count
          @request_count ||= queue.match(/^(\d+)/)[0].to_i
        end
        private :request_count

        # Return the recalled due date
        def recalled_due_date
          @recalled_due_date ||= circulation_status.match(/Recalled due date: (\d{2}\/\d{2}\/\d{2})/)[1]
        end
        private :recalled_due_date

        # Logic to determine whether we're expanding this holding
        # Only expand if not a journal and we've already been to Aleph
        # or we have expanded holdings from Aleph (Aleph could be down) or 
        def expanding?
          @expanding ||= (display_type and (not journal?) and 
            (from_aleph? or expanded_holdings.any?))
        end
        private :expanding?

        # Is this Holding from Aleph?
        def from_aleph?
          @from_aleph ||= source_data[:from_aleph]
        end
        alias :expanded? :from_aleph?

        # Is this a journal
        def journal?
          (display_type and display_type.upcase.eql? "JOURNAL")
        end
        private :journal?

        # Overrides Exlibris::Primo::Holding#coverage to return
        # based on Aleph bib and holdings coverage
        # Only get coverage for journals
        def coverage
          # HACK ALERT: need to find a better way to do this.
          return @coverage unless @coverage.nil? or @coverage.empty?
          @coverage = (journal?) ? (holdings_coverage + bib_coverage) : []
        end

        # Get expanded holdings based on Aleph items.
        def expanded_holdings
          @expanded_holdings ||= aleph_items.collect do |aleph_item|
            source_data = {
              # Flag to short circuit expansion check, since we've already expanded.
              # This says, yes I am source data from Aleph, fool.
              from_aleph: true,
              item_id: aleph_item["href"].match(/items\/(.+)$/)[1],
              adm_library_code: aleph_item["z30"]["translate_change_active_library"],
              call_number: format_aleph_call_number(aleph_item).gsub("&nbsp;", " "),
              sub_library_code: aleph_item["z30_sub_library_code"].strip,
              collection_code: aleph_item["z30_collection_code"],
              source_record_id: source_record_id,
              sequence_number: aleph_item["z30"]["z30_item_sequence"].strip,
              barcode: aleph_item["z30"]["z30_barcode"],
              item_status_code: aleph_item["z30_item_status_code"],
              item_process_status_code: aleph_item["z30_item_process_status_code"],
              item_status: aleph_item["z30"]["z30_item_status"],
              item_process_status: aleph_item["z30"]["z30_item_process_status"],
              circulation_status: aleph_item["status"],
              queue: aleph_item["queue"],
              z30_callno: aleph_item["z30"]["z30_call_no"],
              description: aleph_item["z30"]["z30_description"],
              hol_doc_number: aleph_item["z30"]["z30_hol_doc_number"]
            }
            holding = self.class.new({holding: self, source_data: source_data}.merge(source_data))
          end
        end
        private :expanded_holdings

        # Get Aleph record
        def aleph_record
          @aleph_record ||= 
              Exlibris::Aleph::Record.new(bib_library: original_source_id, record_id: source_record_id)
        end
        private :aleph_record

        # Get Aleph bibliographic info
        # Returns nil if we get an error, e.g. Aleph is down
        def aleph_bib
          @aleph_bib ||= aleph_record.bib
        rescue
          nil
        end
        private :aleph_bib

        # Get Aleph holdings info
        # Returns an empty array if Aleph is down
        def aleph_holdings
          @aleph_holdings ||= aleph_record.holdings
        rescue
          []
        end
        private :aleph_holdings

        # Get Aleph items
        # Returns an empty array if Aleph is down
        def aleph_items
          @aleph_items ||= aleph_record.items
        rescue
          []
        end
        private :aleph_items

        # Get the Aleph "tab" helper
        def aleph_helper
          @aleph_helper ||= Exlibris::Aleph::TabHelper.instance()
        end
        private :aleph_helper

        # Source statuses from config.
        def aleph_statuses
          @aleph_statuses ||= source_config["statuses"] unless source_config.nil?
        end
        private :aleph_statuses

        # ILLiad base url from config.
        def illiad_url
          @illiad_url ||= source_config["illiad_url"] unless source_config.nil?
        end
        private :illiad_url

        # Deferred statuses from config.
        # def deferred_statuses
        #   @deferred_statuses ||= source_config["deferred_statuses"] unless source_config.nil?
        # end
        # private :deferred_statuses

        # Bib 866 subfield l to Aleph sub library map from config.
        def bib_866_subfield_l_map
          @bib_866_subfield_l_map ||= source_config["866$l_mappings"] unless source_config.nil?
        end
        private :bib_866_subfield_l_map

        # Circulation status code based on the source statuses
        # mapping of circulation statuses.
        # Returns nil if the circulation status isn't in the statuses.
        def circulation_status_code
          @circulation_status_code ||= aleph_statuses.keys.find { |key|
            aleph_statuses[key].instance_of?(Array) and
              aleph_statuses[key].include?(circulation_status) }
        end
        private :circulation_status_code

        # Return the Aleph item's web text based on item status
        # and item processing status.
        def item_web_text
          @item_web_text ||= aleph_helper.item_web_text(
            adm_library_code: adm_library_code.downcase,
            sub_library_code: sub_library_code,
            item_status_code: item_status_code,
            item_process_status_code: item_process_status_code ) unless adm_library_code.nil?
        end
        private :item_web_text

        # Is the NyuAleph holding checked out?
        def checked_out?
          @checked_out ||= (aleph_statuses["checked_out"] === circulation_status)
        end
        private :checked_out?

        # Array of coverages already processed.
        # Updated by bib_coverage and holdings_coverage.
        def coverages_seen
          @coverages_seen ||= []
        end
        private :coverages_seen

        # Coverage array from Aleph bib 866$j and 866$k or 866$i.
        def bib_coverage
          return @bib_coverage unless @bib_coverage.nil?
          @bib_coverage = []
          # Only do this if we don't have holdings coverage for this item
          if (@holdings_coverage.nil? || @holdings_coverage.empty?) && aleph_bib
            aleph_bib.each_by_tag('866') do |bib_866|
              # If this bib 866 matches, process it
              if bib_866_matches?(bib_866)
                public_note = bib_866['i']
                @bib_coverage << "Note: #{public_note}" unless public_note.nil?
                # Get the sub library and collection from the bib 866
                (bib_866_sub_library_code, bib_866_collection_code) =
                  sub_library_and_collection_from_bib_866(bib_866)
                # Get the ADM library from the Aleph helper
                adm_library = aleph_helper.sub_library_adm(bib_866_sub_library_code)
                # Punt if we couldn't get the ADM library
                # TODO: log this error state
                next if adm_library.nil?
                # Get the collection display text from the Aleph helper
                collection = aleph_helper.collection_text(
                  adm_library_code: adm_library.downcase,
                  sub_library_code: bib_866_sub_library_code,
                  collection_code: bib_866_collection_code)
                # Punt if we couldn't get the collection display text
                # TODO: log this error state
                next if collection.nil?
                volumes = bib_866['j']
                years = bib_866['k']
                unless years.nil? and years.nil?
                  @bib_coverage <<
                    "Available in #{collection}: #{format_coverage_string(volumes, years)}"
                end
              end
            end
          end
          @bib_coverage
        end
        private :bib_coverage

        def bib_866_matches?(bib_866)
          (bib_866_sub_library_code, bib_866_collection_code) =
            sub_library_and_collection_from_bib_866(bib_866)
          bib_866_sub_library_code == (aleph_sub_library_code || library_code)
        end

        # Get the sub library and collection from the crummy
        # 866 subfield 'l' config mapping. This is problematic
        # but the best we can do at this point.
        def sub_library_and_collection_from_bib_866(bib_866)
          bib_866_subfield_l_mapping = bib_866_subfield_l_map[bib_866['l']]
          bib_866_sub_library_code = bib_866_subfield_l_mapping['sub_library']
          bib_866_collection_code = bib_866_subfield_l_mapping['collection']
          return [bib_866_sub_library_code, bib_866_collection_code]
        end

        # Coverage array from Aleph holdings 852$z and 866$a.
        def holdings_coverage
          return @holdings_coverage unless @holdings_coverage.nil?
          @holdings_coverage = []
          # Only do this if we don't have bib coverage for this item
          if (@bib_coverage.nil? || @bib_coverage.empty?) && aleph_holdings
            aleph_holdings.each do |aleph_holding|
              # If this Aleph holding matches, process it
              if marc_holding_matches?(aleph_holding)
                # Set the public note
                public_note = aleph_holding['852']['z']
                @holdings_coverage << "Note: #{public_note}" unless public_note.nil?
                # Get the holding sub library
                holding_sub_library = aleph_holding['852']['b']
                # Get the ADM library from the Aleph helper
                adm_library = aleph_helper.sub_library_adm(holding_sub_library)
                # Punt if we can't get the ADM library
                # TODO: log this error state
                next if adm_library.nil?
                holding_collection = aleph_holding['852']['c']
                # Get the collection display text from the Aleph helper
                collection = aleph_helper.collection_text(
                  adm_library_code: adm_library.downcase,
                  sub_library_code: holding_sub_library,
                  collection_code: holding_collection)
                # Punt if we can't get the collection display text
                # TODO: log this error state
                next if collection.nil?
                aleph_holding.each_by_tag('866') do |holding_866|
                  textual_holding = holding_866['a']
                  # Punt if we can't get the textual holding
                  next if textual_holding.nil?
                  textual_holding.gsub!(",", ", ")
                  @holdings_coverage << "Available in #{collection}: #{textual_holding}"
                end
              end
            end
          end
          @holdings_coverage
        end
        private :holdings_coverage

        def marc_holding_matches?(marc_holding)
          (aleph_sub_library_code || library_code) == marc_holding['852']['b']
        end

        # Format the Aleph call number for public consumption
        def format_aleph_call_number(aleph_item)
          return "" if aleph_item.nil? or
            (aleph_item["z30"].fetch("z30_call_no", "").nil? and
            aleph_item["z30"].fetch("z30_description", "").nil?)
          return "("+
            de_marc_call_number(aleph_item["z30"].fetch("z30_call_no", ""))+
            ")" if aleph_item["z30"].fetch("z30_description", "").nil?
          return "("+
            aleph_item["z30"].fetch("z30_description", "").to_s +
            ")" if aleph_item["z30"].fetch("z30_call_no", "").nil?
          return "("+
            de_marc_call_number(aleph_item["z30"].fetch("z30_call_no", ""))+
            " "+ aleph_item["z30"].fetch("z30_description", "").to_s+ ")"
        end
        private :format_aleph_call_number

        # Remove MARC markup from the call number
        def de_marc_call_number(marc_call_number)
          marc_call_number.gsub(/\$\$h/, "").gsub(/\$\$i/, " ") unless marc_call_number.nil?
        end
        private :de_marc_call_number

        # Format the coverage string based on give volumes and years.
        def format_coverage_string(volumes, years)
          rv = ""
          rv += "VOLUMES: "+ volumes unless volumes.nil? or volumes.empty?
          rv += " (YEARS: "+ years+ ") " unless years.nil? or years.empty?
          return rv
        end
        private :format_coverage_string
      end
    end
  end
end
