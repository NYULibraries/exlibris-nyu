module Exlibris
  module Nyu
    class Holding
      class Item
        attr_reader :institution, :sub_library, :collection, :status

        # Extra information
        attr_reader :adm_library, :sub_library_code, :collection_code
        attr_reader :item_status_code, :item_process_status_code
        attr_reader :item_id, :item_status, :sequence_number, :barcode, :queue

        def initialize(item)
          # Used to create Translator
          @adm_library = item["z30"]["translate_change_active_library"]
          @sub_library_code = item["z30_sub_library_code"]
          @institution = SubLibraryInstitution.new(sub_library_code).institution
          @collection_code = item["z30_collection_code"]
          @item_status_code = item["z30_item_status_code"]
          @item_process_status_code = item["z30_item_process_status_code"]
          # Used by Holding
          @sub_library = item["z30"]["z30_sub_library"]
          @collection = item["z30"]["z30_collection"]
          @item_status = item["z30"]["z30_item_status"]
          @circulation_status = CirculationStatus.new(item["status"])
          @availability_status = AvailabilityStatus.new(@circulation_status)
          @status = @availability_status.code
          @classification = item["z30"]["z30_call_no"]
          @description = item["z30"]["z30_description"]
          # Not used, but we should pass along
          @item_id = item["href"].match(/items\/(.+)$/)[1]
          @sequence_number = item["z30"]["z30_item_sequence"].strip
          @barcode = item["z30"]["z30_barcode"]
          @queue = item["queue"]
        end

        # The "requestability" of the holding, i.e. under what
        # circumstances is the item requestable
        # Some circulations statuses are non requestable:
        #   - Reshelving
        # If we're considering requestabilty, let a requestability
        # object do the work
        def requestability
          @requestability ||= begin
            if (@circulation_status.reshelving?)
              Exlibris::Nyu::Holding::Requestability::NO
            else
              Exlibris::Nyu::Holding::Requestability.new(translator.item_permissions).value
            end
          end
        end

        def call_number
          @call_number ||= CallNumber.new(@classification, @description).to_s
        end

        def status_display
          @status_display ||= (@availability_status.value || @item_status)
        end

        private
        def translator
          @translator ||= Translator.new(
            adm_library_code: @adm_library,
            sub_library_code: @sub_library_code,
            collection_code: @collection_code,
            item_status_code: @item_status_code,
            item_process_status_code: @item_process_status_code)
        end
      end
    end
  end
end
