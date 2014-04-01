module Exlibris
  module Primo
    module Source
      class NyuAleph
        class Item
          def initialize(item)
            @item_id = item["href"].match(/items\/(.+)$/)[1]
            @adm_library_code = item["z30"]["translate_change_active_library"]
            @sub_library_code = item["z30_sub_library_code"].strip
            @collection_code = item["z30_collection_code"]
            @sequence_number = item["z30"]["z30_item_sequence"].strip
            @barcode = item["z30"]["z30_barcode"]
            @item_status_code = item["z30_item_status_code"]
            @item_process_status_code = item["z30_item_process_status_code"]
            @item_status = item["z30"]["z30_item_status"]
            @item_process_status = item["z30"]["z30_item_process_status"]
            @circulation_status = item["status"]
            @queue = item["queue"]
            @hol_doc_number = item["z30"]["z30_hol_doc_number"]
            @classification = item["z30"]["z30_call_no"]
            @description = item["z30"]["z30_description"]
            @call_number = call_number(item)
          end

          # This kinda sucks. Way too clever. Completely unreadable.
          def to_h
            @hash ||= Hash[
              *(instance_variables.collect { |ivar| 
                [ivar.to_s.gsub('@', '').to_sym, instance_variable_get(ivar)]
              }.flatten)
            ]
          end

          private
          def call_number(item)
            CallNumber.new(@classification, @description).to_s
          end
        end
      end
    end
  end
end
