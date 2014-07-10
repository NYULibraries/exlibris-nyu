module Exlibris
  module Nyu
    module Coverage
      class Statement

        def self.from_record_metadata(collection, record_metadata)
          unless(collection.nil? || collection.is_a?(Exlibris::Aleph::Collection))
            raise ArgumentError.new("Expecting #{collection} to be an Exlibris::Aleph::Collection")
          end
          unless collection.nil? || record_metadata.nil?
            notes = []
            textual_holdings = []
            marc_record = record_metadata.marc_record
            marc_record.each_by_tag('866') do |bib_866|
              bib_866_l = Bib866L.new(bib_866['l'])
              bib_866_collection = find_collection(bib_866_l.sub_library, bib_866_l.collection)
              # If this bib 866 matches the given collection, process it
              if collection == bib_866_collection
                public_note = bib_866['i']
                notes << Note.new(public_note) unless public_note.nil?
                textual_holding = TextualHolding.from_bib_866(collection, bib_866)
                textual_holdings << textual_holding unless textual_holding.nil?
              end
            end
            unless textual_holdings.empty? && notes.empty?
              self.new(textual_holdings, notes)
            end
          end
        end

        def self.from_holdings(collection, holdings)
          unless(collection.nil? || collection.is_a?(Exlibris::Aleph::Collection))
            raise ArgumentError.new("Expecting #{collection} to be an Exlibris::Aleph::Collection")
          end
          unless collection.nil?
            notes = []
            textual_holdings = []
            holdings.each do |holding|
              marc_record = holding.metadata.marc_record
              # Find this holding's collection from the MARC record sub library
              # and collection codes located in the 852 $b and $c respectively
              holding_collection = find_collection(marc_record['852']['b'], marc_record['852']['c'])
              # If this MARC holding matches the given collection, process it
              if collection == holding_collection
                # Set the public note
                public_note = marc_record['852']['z']
                notes << Note.new(public_note) unless public_note.nil?
                marc_record.each_by_tag('866') do |holding_866|
                  textual_holding = holding_866['a']
                  # Punt if we can't get the textual holding
                  next if textual_holding.nil?
                  textual_holding.gsub!(",", ", ")
                  textual_holdings << TextualHolding.new(collection, textual_holding)
                end
              end
            end
            unless textual_holdings.empty? && notes.empty?
              self.new(textual_holdings, notes)
            end
          end
        end

        def self.find_collection(sub_library_code, collection_code)
          collection_finder(sub_library_code, collection_code).collection
        end
        private_class_method :find_collection

        def self.collection_finder(sub_library_code, collection_code)
          Aleph::CollectionFinder.new(sub_library_code, collection_code)
        end
        private_class_method :collection_finder

        attr_reader :textual_holdings, :notes

        def initialize(textual_holdings, notes=[])
          textual_holdings ||= []
          notes ||= []
          unless(textual_holdings.is_a?(Array))
            raise ArgumentError.new("textual_holdings is not an array")
          end
          unless(notes.is_a?(Array))
            raise ArgumentError.new("notes is not an array")
          end
          if textual_holdings.empty? && notes.empty?
            raise ArgumentError.new("textual_holdings and notes can't both be empty")
          end
          @textual_holdings = textual_holdings
          @notes = notes
        end

        def to_a
          @statement_array ||= textual_holdings.map(&:to_s) + notes.map(&:to_s)
        end
      end
    end
  end
end
