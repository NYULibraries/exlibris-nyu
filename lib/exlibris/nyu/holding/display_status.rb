module Exlibris
  module Nyu
    class Holding
      # DisplayStatus further normalizes statuses
      # from the given CirculationStatus.
      # Aka, presentation layer status.
      class DisplayStatus
        DISPLAY_STATUSES = {
          available: "Available",
          unavailable: "Check Availability",
          billed_as_lost: "Request ILL",
          processing: "In Processing",
        }

        attr_reader :circulation_status
        private :circulation_status

        # If we have a CirculationStatus, we came from Aleph
        # (need to think this through)
        def initialize(circulation_status)
          @circulation_status = circulation_status
        end

        def code
          unless circulation_status.code.nil?
            @code ||= "#{circulation_status.code}"
          end
        end

        def value
          @value ||= begin
            if circulation_status.recalled?
              "Due: #{circulation_status.due_date}"
            elsif circulation_status.checked_out?
              "Due: #{circulation_status.value}"
            elsif circulation_status.reshelving?
              "Reshelving"
            elsif DISPLAY_STATUSES.has_key?(circulation_status.code)
              DISPLAY_STATUSES[circulation_status.code]
            elsif circulation_status.value
              circulation_status.value
            end
          end
        end
      end
    end
  end
end
