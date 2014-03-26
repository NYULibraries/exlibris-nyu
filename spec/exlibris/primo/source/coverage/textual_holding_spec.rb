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
