module Exlibris
  module Nyu
    module Aleph
      class Item

        extend Forwardable
        def_delegators :item, :id, :collection

        attr_reader :item, :institution, :sub_library

        def initialize(item)
          unless(item.is_a?(Exlibris::Aleph::Item))
            raise ArgumentError.new("Expecting #{item} to be an Exlibris::Aleph::Item")
          end
          @item = item
          @sub_library = collection.sub_library
          @institution = SubLibraryInstitution.new(sub_library).institution
        end

        def call_number
          @call_number ||= CallNumber.new(item.call_number)
        end

        def status
          @status ||= Status.new(item.circulation_status)
        end

        # The "requestability" of the holding, i.e. under what
        # circumstances is the item requestable
        # Some circulations statuses are non requestable:
        #   - Reshelving
        # If we're considering requestabilty, let a requestability
        # object do the work
        def requestability
          @requestability ||= begin
            if (status.reshelving?)
              Nyu::Aleph::Requestability::NO
            else
              Nyu::Aleph::Requestability.new(privileges).to_s
            end
          end
        end

        private
        def privileges
          @privileges ||= circulation_policy.privileges
        end

        def circulation_policy
          @circulation_policy ||= @item.circulation_policy
        end
      end
    end
  end
end
