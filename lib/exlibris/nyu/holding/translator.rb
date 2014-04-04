module Exlibris
  module Nyu
    module Holding
      class Translator
        attr_reader :adm_library_code, :sub_library_code, :collection_code,
          :item_status_code, :item_process_status_code

        def initialize(attributes)
          @adm_library_code = attributes[:adm_library_code]
          @sub_library_code = attributes[:sub_library_code]
          @adm_library_code ||= adm_from_sub_library
          @adm_library_code = adm_library_code.downcase unless adm_library_code.nil?
          @collection_code = attributes[:collection_code]
          @item_status_code = attributes[:item_status_code]
          @item_process_status_code = attributes[:item_process_status_code]
        end

        def sub_library
          @sub_library ||= helper.sub_library_text(sub_library_code)
        end

        def collection
          @collection ||= helper.collection_text(
            :adm_library_code => adm_library_code,
            :sub_library_code => sub_library_code,
            :collection_code => collection_code)
        end

        def item_status
          @item_status ||= helper.item_web_text(
            adm_library_code: adm_library_code,
            sub_library_code: sub_library_code,
            item_status_code: item_status_code,
            item_process_status_code: item_process_status_code)
        end

        def item_permissions
          @item_permissions ||= helper.item_permissions(
            adm_library_code: adm_library_code,
            sub_library_code: sub_library_code,
            item_status_code: item_status_code,
            item_process_status_code: item_process_status_code)
        end

        private
        def helper
          @helper ||= Exlibris::Aleph::TabHelper.instance
        end

        def adm_from_sub_library
          helper.sub_library_adm(sub_library_code)
        end
      end
    end
  end
end
