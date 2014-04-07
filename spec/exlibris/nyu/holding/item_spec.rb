require 'spec_helper'
module Exlibris
  module Nyu
    describe Holding::Item, vcr: { cassette_name: "virtual inequality" } do
      let(:bib_library) { "NYU01" }
      let(:record_id) { "000980206" }
      let(:aleph_record) { Exlibris::Aleph::Record.new(bib_library: bib_library, record_id: record_id) }
      let(:aleph_item) { aleph_record.items.first }
      subject(:item) { Holding::Item.new(aleph_item) }
      describe '#sub_library' do
        subject { item.sub_library }
        it { should eq 'NYU Bobst' }
      end
      describe '#collection' do
        subject { item.collection }
        it { should eq 'Main Collection' }
      end
      describe '#status' do
        subject { item.status }
        it { should eq 'checked_out' }
      end
      describe '#status_display' do
        subject { item.status_display }
        it { should eq 'Due: 03/07/14' }
      end
      describe '#call_number' do
        subject { item.call_number }
        it { should eq '(HN49.I56 M67 2003)' }
      end
      describe '#requestability' do
        subject { item.requestability }
        it { should eq 'deferred' }
      end
      describe '#item_id' do
        subject { item.item_id }
        it { should eq 'NYU50000980206000010' }
      end
      describe '#item_status' do
        subject { item.item_status }
        it { should eq 'Regular loan' }
      end
      describe '#sequence_number' do
        subject { item.sequence_number }
        it { should eq '1.0' }
      end
      describe '#barcode' do
        subject { item.barcode }
        it { should eq '31142036269960' }
      end
      describe '#queue' do
        subject { item.queue }
        it { should be_nil }
      end
    end
  end
end
