require 'spec_helper'
module Exlibris
  module Nyu
    describe Holding do
      let(:status) { 'available' }
      let(:status_display) { 'Available' }
      let(:institution) { 'NYU' }
      let(:sub_library) { 'NYU Bobst' }
      let(:collection) { 'Main Collection' }
      let(:call_number) { '(0123456789)' }
      let(:requestability) { 'yes' }
      let(:extras) { { key: 'value' } }
      let(:attributes) do
        {
          status: status,
          status_display: status_display,
          institution: institution,
          sub_library: sub_library,
          collection: collection,
          call_number: call_number,
          requestability: requestability,
          extras: extras
        }
      end
      subject(:holding) { Holding.new(attributes) }
      describe '.from_aleph', vcr: { cassette_name: "virtual inequality" } do
        let(:bib_library) { "NYU01" }
        let(:record_id) { "000980206" }
        let(:aleph_record) { Exlibris::Aleph::Record.new(bib_library: bib_library, record_id: record_id) }
        let(:aleph_item) { aleph_record.items.first }
        subject(:holding) {Holding.from_aleph(aleph_item) }
        it { should be_a Holding }
        it 'should have the institution from Aleph' do
          expect(holding.institution).to eq 'NYU'
        end
        it 'should have the location from Aleph' do
          expect(holding.location).to eq 'NYU Bobst Main Collection'
        end
        it 'should have the sub library from Aleph' do
          expect(holding.sub_library).to eq 'NYU Bobst'
        end
        it 'should have the collection from Aleph' do
          expect(holding.collection).to eq 'Main Collection'
        end
        it 'should have the call number from Aleph' do
          expect(holding.call_number).to eq '(HN49.I56 M67 2003)'
        end
        it 'should have the status from Aleph' do
          expect(holding.status).to eq 'checked_out'
        end
        it 'should have the status display from Aleph' do
          expect(holding.status_display).to eq 'Due: 03/07/14'
        end
        it 'should have the requestability from Aleph' do
          expect(holding.requestability).to eq 'deferred'
        end
        let(:extras) do
          {
            adm_library: "NYU50",
            sub_library_code: "BOBST",
            collection_code: "MAIN",
            item_status_code: "01",
            item_process_status_code: nil,
            item_id: 'NYU50000980206000010',
            item_status: 'Regular loan',
            item_sequence_number: '1.0',
            item_barcode: '31142036269960',
            item_queue: nil
          }
        end
        it 'should have extras from Aleph' do
          expect(holding.extras).to eq extras
        end
      end
      describe '#institution' do
        subject { holding.institution }
        it { should eq institution}
      end
      describe '#location' do
        subject { holding.location }
        it { should eq "#{sub_library} #{collection}"}
      end
      describe '#sub_library' do
        subject { holding.sub_library }
        it { should eq sub_library}
      end
      describe '#collection' do
        subject { holding.collection }
        it { should eq collection}
      end
      describe '#call_number' do
        subject { holding.call_number }
        it { should eq call_number}
      end
      describe '#status' do
        subject { holding.status }
        it { should eq status}
      end
      describe '#status_display' do
        subject { holding.status_display }
        it { should eq status_display}
      end
      describe '#extras' do
        subject { holding.extras }
        it { should eq extras}
      end
      describe '#requestability' do
        subject { holding.requestability }
        it { should eq requestability}
      end
      describe '#always_requestable?' do
        subject { holding.always_requestable? }
        context 'when the requestability is "yes"' do
          let(:requestability) { 'yes' }
          it { should be_true }
        end
        context 'when the requestability is "deferred"' do
          let(:requestability) { 'deferred' }
          it { should be_false }
        end
        context 'when the requestability is "no"' do
          let(:requestability) { 'no' }
          it { should be_false }
        end
      end
      describe '#requestable?' do
        subject { holding.requestable? }
        context 'when the requestability is "yes"' do
          let(:requestability) { 'yes' }
          it { should be_true }
        end
        context 'when the requestability is "deferred"' do
          let(:requestability) { 'deferred' }
          it { should be_true }
        end
        context 'when the requestability is "no"' do
          let(:requestability) { 'no' }
          it { should be_false }
        end
      end
      describe '#available?' do
      end
      describe '#recallable?' do
      end
      describe '#requested?' do
      end
      describe '#on_order?' do
      end
      describe '#ill?' do
      end
      describe '#checked_out?' do
      end
      describe '#offsite?' do
      end
    end
  end
end
