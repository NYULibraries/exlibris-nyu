require 'spec_helper'
module Exlibris
  module Primo
    module Source
      module Coverage
        describe TextualHolding do
          let(:collection) { "Main Collection" }
          let(:value) { "coverage information" }
          subject(:textual_holding) { TextualHolding.new(collection, value) }
          it { should be_a TextualHolding }
          describe '.from_bib_866', vcr: { cassette_name: "vogue" } do
            let(:bib_library) { "NYU01" }
            let(:record_id) { "002893728" }
            let(:record) { Exlibris::Aleph::Record.new(bib_library: bib_library, record_id: record_id) }
            let(:marc_bib) { record.bib }
            let(:bib_866) { marc_bib.find { |field| field.tag == '866' } }
            subject { TextualHolding.from_bib_866(collection, bib_866) }
            it { should be_a TextualHolding }
          end
          describe '#collection' do
            subject { textual_holding.collection }
            it { should eq collection }
          end
          describe '#value' do
            subject { textual_holding.value }
            it { should eq value }
          end
          describe '#to_s' do
            subject { textual_holding.to_s }
            it { should eq "Available in #{collection}: #{value}" }
          end
          context 'when initialized with no arguments' do
            it 'should raise an ArgumentError' do
              expect { TextualHolding.new }.to raise_error(ArgumentError)
            end
          end
        end
      end
    end
  end
end
