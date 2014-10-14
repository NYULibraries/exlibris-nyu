require 'spec_helper'
# The Body as Home: COURSES000243396
# MCAT physics review: COURSES000220521
# Overcoming Trauma through Yoga: nyu_aleph003597982
# The Digital Print: COURSES000242493
module Exlibris
  module Primo
    module Source
      describe NyuAlephReserves do
        context 'when initialized with an Exlibris::Aleph::Item' do
            let(:source_id) { 'NYU30'}
            let(:record_id) { "#{source_id}#{source_record_id}" }
            let(:aleph_record) { Exlibris::Aleph::Record.new(record_id) }
            let(:aleph_item) { aleph_record.items.first }
            let(:nyu_aleph_item) { Exlibris::Nyu::Aleph::Item.new(aleph_item) }
            subject(:nyu_aleph_reserves) do
              NyuAlephReserves.new(
                source_id: 'nyu_aleph',
                source_record_id: source_record_id,
                aleph_item: nyu_aleph_item)
            end
          context 'and the Exlibris::Aleph::Item is an NYU personal copy of a book', vcr: {cassette_name: 'the body as home'} do
            let(:source_record_id) {'000243396'}
            it { should be_an NyuAlephReserves }
            it { should be_an NyuAleph }
            it { should be_an Aleph }
            it { should be_an Exlibris::Primo::Holding }
            describe '#status' do
              subject { nyu_aleph_reserves.status }
              it { should be_a Exlibris::Nyu::Aleph::ReservesStatus }
            end
          end
          context 'and the Exlibris::Aleph::Item is an NYU personal copy of a journal', vcr: {cassette_name: 'mcat physics review'} do
            let(:source_record_id) {'000220521'}
            it { should be_an NyuAlephReserves }
            it { should be_an NyuAleph }
            it { should be_an Aleph }
            it { should be_an Exlibris::Primo::Holding }
            describe '#status' do
              subject { nyu_aleph_reserves.status }
              it { should be_a Exlibris::Nyu::Aleph::ReservesStatus }
            end
          end
          context 'and the Exlibris::Aleph::Item is an NYU book', vcr: {cassette_name: 'overcoming trauma through yoga'} do
            let(:source_id) { 'NYU01'}
            let(:source_record_id) {'003597982'}
            it { should be_an NyuAlephReserves }
            it { should be_an NyuAleph }
            it { should be_an Aleph }
            it { should be_an Exlibris::Primo::Holding }
            describe '#status' do
              subject { nyu_aleph_reserves.status }
              it { should be_a Exlibris::Nyu::Aleph::ReservesStatus }
            end
          end
          context 'and the Exlibris::Aleph::Item is a New School book', vcr: {cassette_name: 'the digital print'} do
            let(:source_record_id) {'000242493'}
            it { should be_an NyuAlephReserves }
            it { should be_an NyuAleph }
            it { should be_an Aleph }
            it { should be_an Exlibris::Primo::Holding }
            describe '#status' do
              subject { nyu_aleph_reserves.status }
              it { should be_a Exlibris::Nyu::Aleph::ReservesStatus }
            end
          end
        end
      end
    end
  end
end
