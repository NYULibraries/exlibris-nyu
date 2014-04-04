require 'spec_helper'
# Vogue: nyu_aleph002893728
# Visionaire: nyu_aleph001951476
module Exlibris
  module Primo
    module Source
      describe NyuAleph do
        let(:aleph_holding) { }
        subject(:nyu_aleph) { NyuAleph.new(aleph_holding: aleph_holding) }
        it { should be_an NyuAleph }
        it { should be_an Aleph }
        it { should be_an Exlibris::Primo::Holding }
        describe 'from_aleph?' do
          subject { nyu_aleph.from_aleph? }
          context 'when expanded from Aleph' do
            xit { should be_true }
          end
          context 'when not expanded from Aleph' do
            xit { should be_false }
          end
        end
        describe 'expanded?' do
          subject { nyu_aleph.expanded? }
          context 'when expanded from Aleph' do
            xit { should be_true }
          end
          context 'when not expanded from Aleph' do
            xit { should be_false }
          end
        end
        context 'when initialized with a Journal holding', vcr: { cassette_name: "vogue" } do
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
