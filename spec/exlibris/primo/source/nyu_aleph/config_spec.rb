require 'spec_helper'
module Exlibris
  module Primo
    module Source
      describe NyuAleph::Config do
        let(:source) { Primo.config.sources['nyu_aleph'] }
        subject(:config) { NyuAleph::Config.new(source) }
        it { should be_an NyuAleph::Config }
        describe '#institutions' do
          subject { config.institutions }
          it { should be_a Hash }
          it { should have_key "BOBST" }
          it 'should map BOBST to NYU' do
            expect(subject["BOBST"]).to eq "NYU"
          end
        end
        context 'when initialized without any arguments' do
          it 'should raise an ArgumentError' do
            expect { NyuAleph::Config.new }.to raise_error ArgumentError
          end
        end
      end
    end
  end
end
