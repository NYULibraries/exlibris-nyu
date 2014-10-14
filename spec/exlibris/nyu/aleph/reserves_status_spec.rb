require 'spec_helper'
module Exlibris
  module Nyu
    module Aleph
      describe ReservesStatus, vcr: {cassette_name: 'the body as home'} do
        let(:value) { 'On Shelf' }
        let(:circulation_status) do
          Exlibris::Aleph::Item::CirculationStatus.new(value)
        end
        let(:status) { Status.new(circulation_status) }
        let(:source_id) { 'NYU30'}
        let(:source_record_id) { '000243396' }
        let(:record_id) { "#{source_id}#{source_record_id}" }
        let(:record) { Exlibris::Aleph::Record.new(record_id) }
        let(:item) { record.items.first }
        let(:item_status) { item.status }
        subject(:reserves_status) { ReservesStatus.new(status, item_status) }
        describe '#status' do
          subject { reserves_status.status }
          it { should eq status }
        end
        describe '#item_status' do
          subject { reserves_status.item_status }
          it { should eq item_status }
        end
        describe '#value' do
          subject { reserves_status.value }
          context 'when the item is available' do
            it { should eq 'Available - Reserve 2 hour loan' }
          end
          context 'when the item is checked out' do
            let(:value) { '05/31/14' }
            it { should eq 'Due: 05/31/14' }
          end
        end
        describe '#to_s' do
          subject { reserves_status.to_s }
          it { should eq reserves_status.value }
        end
        describe '#available?' do
          subject { reserves_status.available? }
          it { should_not be nil }
        end
        describe '#offsite?' do
          subject { reserves_status.offsite? }
          it { should_not be nil }
        end
        describe '#requested?' do
          subject { reserves_status.requested? }
          it { should_not be nil }
        end
        describe '#billed_as_lost?' do
          subject { reserves_status.billed_as_lost? }
          it { should_not be nil }
        end
        describe '#unavailable?' do
          subject { reserves_status.unavailable? }
          it { should_not be nil }
        end
        describe '#processing?' do
          subject { reserves_status.processing? }
          it { should_not be nil }
        end
        describe '#reshelving?' do
          subject { reserves_status.reshelving? }
          it { should_not be nil }
        end
        describe '#checked_out?' do
          subject { reserves_status.checked_out? }
          it { should_not be nil }
        end
        describe '#recalled?' do
          subject { reserves_status.checked_out? }
          it { should_not be nil }
        end
        describe '#requested?' do
          subject { reserves_status.checked_out? }
          it { should_not be nil }
        end

        context 'when initialized with a status that is not an Exlibris::Nyu::Aleph::Status' do
          let(:status) { :invalid }
          it 'should raise an ArgumentError' do
            expect { subject }.to raise_error ArgumentError
          end
        end
        context 'when initialized with an item_status that is not an Exlibris::Aleph::Item::Status' do
          let(:item_status) { :invalid }
          it 'should raise an ArgumentError' do
            expect { subject }.to raise_error ArgumentError
          end
        end
      end
    end
  end
end
