module Exlibris
  module Primo
    module Source
      class NyuAleph
        class CirculationStatus
          # Enum of status mappings
          # http://rails-bestpractices.com/posts/708-clever-enums-in-rails
          STATUSES = {
            available: AVAILABLE = ["On Shelf", "Available"],
            offsite: OFFSITE = ["Offsite Available"],
            requested: REQUESTED = ["Requested", "On Hold"],
            billed_as_lost: BILLED_AS_LOST = ["Billed as Lost", "Claimed Returned"],
            unavailable: UNAVAILABLE = ["Unavailable"],
            processing: PROCESSING = ["In Processing", "In Transit"]
          }

          # Define "status?" methods
          STATUSES.each do |code, statuses|
            define_method "#{code}?".to_sym do
              statuses.include?(value)
            end
          end

          attr_reader :value

          def initialize(value)
            @value = value
          end

          def code
            @code ||= begin
              if pair_found?
                found_pair.first
              elsif recalled?
                :recalled
              elsif checked_out?
                :checked_out
              elsif requested?
                :requested
              elsif reshelving?
                :reshelving
              end
            end
          end

          # Is this holding requested?
          def requested?
            (/Requested/ === value || REQUESTED.include?(value))
          end

          # Is this holding recalled?
          def recalled?
            /Recalled/ === value
          end

          # Are we reshelving this item?
          def reshelving?
            /Reshelving/ === value
          end

          def checked_out?
            /([0-9]{2}\/[0-9]{2}\/[0-9]{2})/ === value
          end

          def due_date
            @due_date ||= due_date_match[0] unless due_date_match.nil?
          end

          private
          def pair_found?
            !found_pair.nil?
          end

          def found_pair
            @found_pair ||= STATUSES.each_pair.find { |code, statuses|
              statuses.include?(value)
            }
          end

          def due_date_match
            @due_date_match ||= value.match(/\d{2}\/\d{2}\/\d{2}/)
          end
        end
      end
    end
  end
end
