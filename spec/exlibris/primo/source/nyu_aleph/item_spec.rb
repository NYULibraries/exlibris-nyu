require 'spec_helper'
module Exlibris
  module Primo
    module Source
      describe NyuAleph::Item, vcr: { cassette_name: "virtual inequality" } do
        let(:bib_library) { "NYU01" }
        let(:record_id) { "000980206" }
        let(:aleph_record) { Exlibris::Aleph::Record.new(bib_library: bib_library, record_id: record_id) }
        let(:aleph_item) { aleph_record.items.first }
        subject(:item) { NyuAleph::Item.new(aleph_item) }
        describe '#to_h' do
          subject { item.to_h }
          it { should be_a Hash }
          it { should_not be_empty }
        end
      end
    end
  end
end
