require 'spec_helper'
module Exlibris
  module Primo
    module Source
      describe NyuAleph do
        subject(:nyu_aleph) { NyuAleph.new }
        it { should be_an NyuAleph }
        context 'when initialized with a Vogue holding', vcr: { cassette_name: "vogue", record: :new_episodes } do
          let(:vogue) { "nyu_aleph002893728" }
          let(:search) { Exlibris::Primo::Search.new(record_id: vogue) }
          let(:records) { search.records }
          let(:holdings) { records.map{ |record| record.holdings }.flatten }
          subject(:vogue_nyu_aleph) { NyuAleph.new(holding: holding) }
          context 'and the holding is at NYU' do
            let(:holding) do
              holdings.find { |holding| holding.institution_code == "NYU" }
            end
            it { should be_an NyuAleph }
            describe '#coverage' do
              subject { vogue_nyu_aleph.coverage }
              it { should be_an Array }
              it { should_not be_empty }
              it 'should have 2 elements' do
                expect(subject.size).to be 2
              end
            end
          end
          context 'and the holding is at the New School' do
            let(:holding) do
              holdings.find { |holding| holding.institution_code == "NS" }
            end
            it { should be_an NyuAleph }
            describe '#coverage' do
              subject { vogue_nyu_aleph.coverage }
              it { should be_an Array }
              it { should_not be_empty }
              it 'should have 2 elements' do
                expect(subject.size).to be 2
              end
            end
          end
          context 'and the holding is at the New-York Historical Society' do
            let(:holding) do
              holdings.find { |holding| holding.institution_code == "NYHS" }
            end
            it { should be_an NyuAleph }
            describe '#coverage' do
              subject { vogue_nyu_aleph.coverage }
              it { should be_an Array }
              it { should_not be_empty }
              it 'should have 1 element' do
                expect(subject.size).to be 1
              end
            end
          end
        end
      end
    end
  end
end
