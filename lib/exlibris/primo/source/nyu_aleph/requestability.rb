module Exlibris
  module Primo
    module Source
      class NyuAleph
        class Requestability
          # The item is always requestable
          YES = 'yes'
          # The item's requestability depends on other factors,
          # e.g. user's permissions
          DEFERRED = 'deferred'
          # The item is never requestable
          NO = 'no'

          attr_reader :value

          def initialize(item_permissions)
            @item_permissions = item_permissions
            # If the holding permission is "C" it is requestable.
            # Also if the ILL permission is "Y", it is requestable.
            # If the holding permission is "Y", some users can request
            # so we must defer the decision.
            @value ||= begin
              if (hold_permission == 'C' || ill_permission == 'Y')
                YES
              elsif hold_permission == 'Y'
                DEFERRED
              else
                NO
              end
            end
          end

          private
          def hold_permission
            unless @item_permissions.nil?
              @hold_permission ||= @item_permissions[:hold_request]
            end
          end

          def ill_permission
            unless @item_permissions.nil?
              @ill_permission ||= @item_permissions[:photocopy_request]
            end
          end
        end
      end
    end
  end
end
