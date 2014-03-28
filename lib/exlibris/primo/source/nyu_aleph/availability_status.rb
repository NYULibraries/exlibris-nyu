module Exlibris
  module Primo
    module Source
      class NyuAleph
        class AvailabilityStatus
          AVALABILITY_STATUSES = {
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
              if circulation_status.recalled? || circulation_status.checked_out?
                "Due: #{circulation_status.due_date}"
              elsif circulation_status.reshelving?
                "Reshelving"
              elsif AVALABILITY_STATUSES[circulation_status.code]
                AVALABILITY_STATUSES[circulation_status.code]
              elsif circulation_status.value
                circulation_status.value
              end
            end
          end
        end
      end
    end
  end
end
