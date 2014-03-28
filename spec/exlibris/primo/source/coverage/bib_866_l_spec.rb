require 'spec_helper'
module Exlibris
  module Primo
    module Source
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
          end
          describe '#collection' do
            subject { bib_866_l.collection }
            it { should eq "MAIN" }
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
end
