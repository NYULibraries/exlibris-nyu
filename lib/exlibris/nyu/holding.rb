module Exlibris
  module Nyu
    class Holding
      STATUSES = {
        available: ['available'],
        recallable: ['checked_out', 'requested'],
        processing: ['processing'],
        offsite: ['offsite'],
        checked_out: ['checked_out'],
        on_order: ["On Order"],
        ill: ['Request ILL', 'On Order', 'processing', 'checked_out', 'requested']
      }

      attr_reader :status, :status_display, :institution, :sub_library,
        :collection, :location, :call_number, :requestability, :extras

      def self.from_aleph(aleph_item)
        item = Item.new(aleph_item)
        attributes = {
          status: item.status,
          status_display: item.status_display,
          institution: item.institution,
          sub_library: item.sub_library,
          collection: item.collection,
          call_number: item.call_number,
          requestability: item.requestability,
          extras: {
            adm_library: item.adm_library,
            sub_library_code: item.sub_library_code,
            collection_code: item.collection_code,
            item_status_code: item.item_status_code,
            item_process_status_code: item.item_process_status_code,
            item_id: item.item_id,
            item_status: item.item_status,
            item_sequence_number: item.sequence_number,
            item_barcode: item.barcode,
            item_queue: item.queue
          }
        }
        self.new(attributes)
      end

      # Define "status?" methods
      STATUSES.each do |code, statuses|
        define_method "#{code}?".to_sym do
          statuses.include?(status) || statuses.include?(status_display)
        end
      end

      def initialize(attributes)
        @status = attributes[:status]
        @status_display = attributes[:status_display]
        # @status_display ||= mapped_status
        @sub_library = attributes[:sub_library]
        @institution = attributes[:institution]
        @collection = attributes[:collection]
        @location = "#{sub_library} #{collection}"
        @call_number = attributes[:call_number]
        @requestability = attributes[:requestability]
        @extras = attributes[:extras]
      end

      # Is this holding requested?
      def requested?
        /Requested/ === status_display
      end

      def always_requestable?
        requestability == Requestability::YES
      end

      def requestable?
        always_requestable? || requestability == Requestability::DEFERRED
      end
    end
  end
end
