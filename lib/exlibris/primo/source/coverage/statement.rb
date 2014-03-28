module Exlibris
  module Primo
    module Source
      module Coverage
        class Statement

          def self.from_marc_bib(sub_library, marc_bib)
            unless marc_bib.nil?
              notes = []
              textual_holdings = []
              marc_bib.each_by_tag('866') do |bib_866|
                bib_866_l = Bib866L.new(bib_866['l'])
                # If this bib 866 matches, process it
                if sub_library == bib_866_l.sub_library
                  public_note = bib_866['i']
                  notes << Note.new(public_note) unless public_note.nil?
                  translator = Exlibris::Primo::Source::NyuAleph::Translator.new(
                    sub_library_code: bib_866_l.sub_library,
                    collection_code: bib_866_l.collection)
                  # Punt if we couldn't get the ADM library
                  # TODO: log this error state
                  next if translator.adm_library_code.nil?
                  # Get the collection display text from the translator
                  collection = translator.collection
                  # Punt if we couldn't get the collection display text
                  # TODO: log this error state
                  next if collection.nil?
                  textual_holding = TextualHolding.from_bib_866(collection, bib_866)
                  textual_holdings << textual_holding unless textual_holding.nil?
                end
              end
              unless textual_holdings.empty? && notes.empty?
                self.new(textual_holdings, notes)
              end
            end
          end

          def self.from_marc_holdings(sub_library, marc_holdings)
            notes = []
            textual_holdings = []
            marc_holdings.each do |marc_holding|
              # Get the MARC holding sub library
              holding_sub_library = marc_holding['852']['b']
              # If this MARC holding matches, process it
              if sub_library == holding_sub_library
                # Set the public note
                public_note = marc_holding['852']['z']
                notes << Note.new(public_note) unless public_note.nil?
                holding_collection = marc_holding['852']['c']
                translator = Exlibris::Primo::Source::NyuAleph::Translator.new(
                  sub_library_code: holding_sub_library,
                  collection_code: holding_collection)
                # Punt if we can't get the ADM library
                # TODO: log this error state
                next if translator.adm_library_code.nil?
                # Get the collection display text from the translator
                collection = translator.collection
                # Punt if we can't get the collection display text
                # TODO: log this error state
                next if collection.nil?
                marc_holding.each_by_tag('866') do |holding_866|
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
end
