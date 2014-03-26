require 'spec_helper'
# Vogue: nyu_aleph002893728
# Visionaire: nyu_aleph001951476
module Exlibris
  module Primo
    module Source
      describe NyuAleph do
        subject(:nyu_aleph) { NyuAleph.new }
        it { should be_an NyuAleph }
        context 'when initialized with a Journal holding', vcr: { cassette_name: "vogue", record: :new_episodes } do
          let(:record_id) { "nyu_aleph002893728" }
          let(:search) { Exlibris::Primo::Search.new(record_id: record_id) }
          let(:records) { search.records }
          let(:holdings) { records.map{ |record| record.holdings }.flatten }
          subject(:vogue_nyu_aleph) { NyuAleph.new(holding: holding) }
          context 'and the holding has coverage statements in the bib MARC' do
            let(:holding) do
              holdings.find { |holding| holding.institution_code == "NYU" }
            end
            it { should be_an NyuAleph }
            describe '#coverage' do
              subject { vogue_nyu_aleph.coverage }
              it { should be_an Array }
              it { should_not be_empty }
              it 'should display the bib coverage statement' do
                expect(subject.size).to be 2
              end
            end
          end
          context 'and the holding has coverage statements in the holding MARC' do
            let(:holding) do
              holdings.find { |holding| holding.institution_code == "NS" }
            end
            it { should be_an NyuAleph }
            describe '#coverage' do
              subject { vogue_nyu_aleph.coverage }
              it { should be_an Array }
              it { should_not be_empty }
              it 'should display the holding coverage statement' do
                expect(subject.size).to be 2
              end
            end
          end
          context 'and the holding has coverage statements in both the bib and holding MARC' do
            let(:holding) do
              holdings.find { |holding| holding.institution_code == "NYHS" }
            end
            it { should be_an NyuAleph }
            describe '#coverage' do
              subject { vogue_nyu_aleph.coverage }
              it { should be_an Array }
              it { should_not be_empty }
              it 'should display the holding coverage statement' do
                expect(subject.size).to be 1
              end
            end
          end
        end
      end
    end
  end
end
