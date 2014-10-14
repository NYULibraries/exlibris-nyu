module Exlibris
  module Nyu
    module Aleph
      class ReservesStatus

        extend Forwardable
        def_delegators :status, :available?, :offsite?, :requested?,
          :billed_as_lost?, :unavailable?, :processing?, :reshelving?,
          :checked_out?, :recalled?, :requested?

        attr_reader :status, :item_status

        def initialize(status, item_status)
          unless(status.is_a?(Exlibris::Nyu::Aleph::Status))
            raise ArgumentError.new("Expecting #{status} to be an Exlibris::Nyu::Aleph::Status")
          end
          unless(item_status.is_a?(Exlibris::Aleph::Item::Status))
            raise ArgumentError.new("Expecting #{item_status} to be an Exlibris::Aleph::Item::Status")
          end
          @status = status
          @item_status = item_status
        end

        def value
          @value ||= begin
            if status.available?
              "#{status.value} - #{item_status}"
            else
              status.value
            end
          end
        end

        def to_s
          value
        end
      end
    end
  end
end
