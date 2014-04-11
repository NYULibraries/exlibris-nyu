require 'spec_helper'
module Exlibris
  module Nyu
    module Coverage
      describe Bib866L do
        let(:value) { "NYHistSoc" }
        subject(:bib_866_l) { Bib866L.new(value) }
        describe '#value' do
          subject { bib_866_l.value }
          it { should eq value }
        end
        describe '#sub_library' do
          subject { bib_866_l.sub_library }
          it { should eq "NYHS" }
          context 'when there is not a mapping' do
            let(:value) { "invalid" }
            it { should be_nil }
          end
        end
        describe '#collection' do
          subject { bib_866_l.collection }
          it { should eq "MAIN" }
          context 'when there is not a mapping' do
            let(:value) { "invalid" }
            it { should be_nil }
          end
        end
        context 'when initialized without any arguments' do
          it 'should raise an ArgumentError' do
            expect { Bib866L.new }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end
end
