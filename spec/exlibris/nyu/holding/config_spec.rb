require 'spec_helper'
module Exlibris
  module Nyu
    module Holding
      describe Config do
        let(:source) { Primo.config.sources['nyu_aleph'] }
        subject(:config) { Config.new(source) }
        it { should be_an Config }
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
            expect { Config.new }.to raise_error ArgumentError
          end
        end
      end
    end
  end
end
