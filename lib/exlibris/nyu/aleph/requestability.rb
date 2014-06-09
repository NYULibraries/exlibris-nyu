module Exlibris
  module Nyu
    module Aleph
      class Requestability
        # The item is always requestable
        YES = 'yes'
        # The item's requestability depends on other factors,
        # e.g. user's permissions
        DEFERRED = 'deferred'
        # The item is never requestable
        NO = 'no'

        attr_reader :privileges

        def initialize(privileges)
          unless(privileges.is_a?(Exlibris::Aleph::Item::CirculationPolicy::Privileges))
            raise ArgumentError.new("Expecting #{privileges} to be an Exlibris::Aleph::Item::CirculationPolicy::Privileges")
          end
          @privileges = privileges
        end

        def to_s
          @value ||= begin
            if (privileges.always_requestable? || privileges.photocopyable?)
              YES
            elsif privileges.requestable?
              DEFERRED
            else
              NO
            end
          end
        end
      end
    end
  end
end
