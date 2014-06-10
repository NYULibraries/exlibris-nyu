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
          unless collection.nil?
            @sub_library = collection.sub_library
          end
          unless sub_library.nil?
            @institution = SubLibraryInstitution.new(sub_library).institution
          end
        end

        def call_number
          unless item.call_number.nil?
            @call_number ||= CallNumber.new(item.call_number)
          end
        end

        def status
          unless item.circulation_status.nil?
            @status ||= Status.new(item.circulation_status)
          end
        end

        # The "requestability" of the holding, i.e. under what
        # circumstances is the item requestable
        # Some circulations statuses are non requestable:
        #   - Reshelving
        # If we're considering requestabilty, let a requestability
        # object do the work
        def requestability
          @requestability ||= begin
            if (status.nil? || status.reshelving? || privileges.nil?)
              Nyu::Aleph::Requestability::NO
            else
              Nyu::Aleph::Requestability.new(privileges).to_s
            end
          end
        end

        private
        def privileges
          unless circulation_policy.nil?
            @privileges ||= circulation_policy.privileges
          end
        end

        def circulation_policy
          @circulation_policy ||= @item.circulation_policy
        end
      end
    end
  end
end
