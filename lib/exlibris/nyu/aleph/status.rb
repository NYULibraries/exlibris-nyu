module Exlibris
  module Nyu
    module Aleph
      class Status

        extend Forwardable
        def_delegators :circulation_status, :due_date

        attr_reader :circulation_status, :value

        # Enum of status mappings
        # http://rails-bestpractices.com/posts/708-clever-enums-in-rails
        STATUSES = {
          available: AVAILABLE = ["On Shelf", "Available", "Regular loan",
            "Video", "Library use only", "Microform", "Multi-Media", "Periodicals",
            "Reference", "Recorded music", "Juvenile", "Leisure", "Special",
            "Spoken Word", "In house loan", "Special Collection", "US documents",
            "International documents", "Reserve 2 hour loan", "Reserve 4 hour loan",
            "Reserve 6 hour loan", "Reserve 24 hour loan", "Reserve 3 day loan",
            "Reserve 7 day loan", "Reserve 14 day loan", "Reserve 3 hour loan",
            "Reserve 2 hour photocopy", "Reserve 4 hour loan AFC", "Hourly loan",
            "BTECH", "BMICR", "NYU GREY ART", "REF6NYCENSUS", "NYAA", "INET1", "BMEZZ", "CD Rom"],
          offsite: OFFSITE = ["Offsite Available"],
          requested: REQUESTED = ["Requested", "On Hold"],
          billed_as_lost: BILLED_AS_LOST = ["Billed as Lost", "Claimed Returned"],
          unavailable: UNAVAILABLE = ["Unavailable"],
          processing: PROCESSING = ["In Processing", "In Transit"]
        }

        # Define "status?" methods
        STATUSES.each do |code, statuses|
          define_method "#{code}?".to_sym do
            statuses.include?(circulation_status.value)
          end
        end

        def initialize(circulation_status)
          unless(circulation_status.is_a?(Exlibris::Aleph::Item::CirculationStatus))
            raise ArgumentError.new("Expecting #{circulation_status} to be an Exlibris::Aleph::Item:CirculationStatus")
          end
          @circulation_status = circulation_status
          @value ||= begin
            if recalled?
              "Due: #{due_date}"
            elsif checked_out?
              "Due: #{circulation_status.value}"
            elsif reshelving?
              'Reshelving'
            elsif available?
              'Available'
            elsif unavailable?
              'Check Availability'
            elsif processing?
              'In Processing'
            elsif billed_as_lost?
              'Request ILL'
            else
              circulation_status.value
            end
          end
        end

        def to_s
          value
        end

        # Are we reshelving this item?
        def reshelving?
          /Reshelving/ === circulation_status.value
        end

        def checked_out?
          /([0-9]{2}\/[0-9]{2}\/[0-9]{2})/ === circulation_status.value
        end

        # Is this item recalled?
        def recalled?
          /Recalled/ === circulation_status.value
        end

        # Is this item requested?
        def requested?
          (/Requested/ === circulation_status.value ||
            REQUESTED.include?(circulation_status.value))
        end
      end
    end
  end
end
