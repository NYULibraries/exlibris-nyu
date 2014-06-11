require 'spec_helper'
module Exlibris
  module Nyu
    module Aleph
      describe Item, vcr: { cassette_name: 'virtual inequality', record: :new_episodes } do
        let(:admin_library) { Exlibris::Aleph::AdminLibrary.new('NYU50') }
        let(:sub_library) do
          Exlibris::Aleph::SubLibrary.new('BOBST', 'NYU Bobst', admin_library)
        end
        let(:collection) do
          Exlibris::Aleph::Collection.new('MAIN', 'Main Collection', sub_library)
        end
        let(:record_id) { 'NYU01000980206' }
        let(:record) { Exlibris::Aleph::Record.new(record_id) }
        let(:record_items) { record.items }
        let(:record_item) { record_items.first }
        subject(:item) { Item.new(record_item) }
        describe '#sub_library' do
          subject { item.sub_library }
          it { should be_an Exlibris::Aleph::SubLibrary }
          it { should eq sub_library }
        end
        describe '#collection' do
          subject { item.collection }
          it { should be_an Exlibris::Aleph::Collection }
          it { should eq collection }
        end
        describe '#call_number' do
          subject { item.call_number }
          it { should be_a CallNumber }
          it 'should equal "(HN49.I56 M67 2003)"' do
            expect("#{subject}").to eq '(HN49.I56 M67 2003)'
          end
        end
        describe '#status' do
          subject { item.status }
          it { should be_a Status }
          it 'should equal "Due: 06/28/14"' do
            expect("#{subject}").to eq 'Due: 06/28/14'
          end
        end
        describe '#opac_note' do
          subject { item.opac_note }
          it { should be_a Exlibris::Aleph::Item::OpacNote }
          it 'should equal "OPAC Note"' do
            expect("#{subject}").to eq 'OPAC Note'
          end
        end
        describe '#queue' do
          subject { item.queue }
          it { should be_a Exlibris::Aleph::Item::Queue }
          it 'should equal "1 request(s) of 1 items."' do
            expect("#{subject}").to eq '1 request(s) of 1 items.'
          end
        end
        describe '#requestability' do
          subject { item.requestability }
          it { should eq Requestability::DEFERRED }
          context 'when the circulation status value is "Reshelving"' do
            let(:circulation_status_value) { 'Reshelving' }
            let(:circulation_status) do
              Exlibris::Aleph::Item::CirculationStatus.new(circulation_status_value)
            end
            before do
              allow(record_item).to receive(:circulation_status).and_return(circulation_status)
            end
            it { should eq Requestability::NO }
          end
        end
        describe '#id' do
          subject { item.id }
          it { should eq 'NYU50000980206000010' }
        end
        context 'when initialized with an item argument which is not an Exlibris::Aleph::Item' do
          let(:record_item) { 'invalid' }
          it 'should raise an ArgumentError' do
            expect { subject }.to raise_error ArgumentError
          end
        end
        context 'when initialized with an item argument which is an Exlibris::Aleph::Item' do
          context 'but the Item is not valid' do
            let(:item_id) { 'ADM50' }
            let(:record_item) { Exlibris::Aleph::Item.new(record_id, item_id) }
            describe '#sub_library' do
              subject { item.sub_library }
              it { should be_nil }
            end
            describe '#collection' do
              subject { item.collection }
              it { should be_nil }
            end
            describe '#call_number' do
              subject { item.call_number }
              it { should be_nil }
            end
            describe '#status' do
              subject { item.status }
              it { should be_nil }
            end
            describe '#requestability' do
              subject { item.requestability }
              it { should eq Requestability::NO }
            end
          end
        end
      end
    end
  end
end
