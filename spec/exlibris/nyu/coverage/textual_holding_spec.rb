require 'spec_helper'
module Exlibris
  module Nyu
    module Coverage
      describe TextualHolding do
        let(:collection) { "Main Collection" }
        let(:value) { "coverage information" }
        subject(:textual_holding) { TextualHolding.new(collection, value) }
        it { should be_a TextualHolding }
        describe '.from_bib_866', vcr: { cassette_name: "vogue" } do
          let(:record_id) { 'NYU01002893728' }
          let(:record) { Exlibris::Aleph::Record.new(record_id) }
          let(:record_metadata) { record.metadata }
          let(:marc_record) { record_metadata.marc_record }
          let(:bib_866) { marc_record.find { |field| field.tag == '866' } }
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
