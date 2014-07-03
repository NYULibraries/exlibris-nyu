require 'spec_helper'
module Exlibris
  module Nyu
    module Aleph
      describe Status do
        let(:value) { 'On Shelf' }
        let(:circulation_status) do
          Exlibris::Aleph::Item::CirculationStatus.new(value)
        end
        subject(:status) do
          Status.new(circulation_status)
        end
        describe '#circulation_status' do
          subject { status.circulation_status }
          it { should be_an Exlibris::Aleph::Item::CirculationStatus }
          it { should eq circulation_status }
        end
        describe '#value' do
          subject { status.value }
          it { should eq 'Available' }
          context 'when the value is "Recalled due date: 05/31/14"' do
            let(:value) { 'Recalled due date: 05/31/14' }
            it { should eq 'Due: 05/31/14' }
          end
          context '#when the value is "05/31/14"' do
            let(:value) { '05/31/14' }
            it { should eq 'Due: 05/31/14' }
          end
          context '#when the value is "05/31/14"' do
            let(:value) { '05/31/14; Requested' }
            it { should eq 'Due: 05/31/14; Requested' }
          end
          context 'when the value is "Unavailable"' do
            let(:value) { 'Unavailable' }
            it { should eq 'Check Availability' }
          end
          context 'when the value is "In Transit"' do
            let(:value) { 'In Transit' }
            it { should eq 'In Processing' }
          end
          context 'when the value is "In Processing"' do
            let(:value) { 'In Processing' }
            it { should eq 'In Processing' }
          end
          context 'when the value is "Billed as Lost"' do
            let(:value) { 'Billed as Lost' }
            it { should eq 'Request ILL' }
          end
          context 'when the value is "Claimed Returned"' do
            let(:value) { 'Claimed Returned' }
            it { should eq 'Request ILL' }
          end
          context 'when the value is "Requested"' do
            let(:value) { 'Requested' }
            it { should eq 'Requested' }
          end
          context 'when the value is "On Hold"' do
            let(:value) { 'On Hold' }
            it { should eq 'On Hold' }
          end
          context 'when the value is "Offsite Available"' do
            let(:value) { 'Offsite Available' }
            it { should eq 'Offsite Available' }
          end
          context 'when the value is "Request ILL"' do
            let(:value) { 'Request ILL' }
            it { should eq 'Request ILL' }
          end
        end
        describe '#to_s' do
          subject { "#{status}" }
          it { should eq 'Available' }
        end
        describe '#due_date' do
          subject { status.due_date }
          it { should be_nil }
          context 'when the value is "05/31/14"' do
            let(:value) { '05/31/14' }
            it { should eq '05/31/14' }
          end
        end
        describe '#available?' do
          subject { status.available? }
          it { should be_true }
          context 'when the value is "Available"' do
            let(:value) { 'Available' }
            it { should be_true }
          end
          context 'when the value is "05/31/14"' do
            let(:value) { '05/31/14' }
            it { should be_false }
          end
        end
        describe '#offsite?' do
          subject { status.offsite? }
          it { should be_false }
          context 'when the value is "Offsite Available"' do
            let(:value) { 'Offsite Available' }
            it { should be_true }
          end
        end
        describe '#billed_as_lost?' do
          subject { status.billed_as_lost? }
          it { should be_false }
          context 'when the value is "Billed as Lost"' do
            let(:value) { 'Billed as Lost' }
            it { should be_true }
          end
          context 'when the value is "Claimed Returned"' do
            let(:value) { 'Claimed Returned' }
            it { should be_true }
          end
        end
        describe '#processing?' do
          subject { status.processing? }
          it { should be_false }
          context 'when the value is "In Processing"' do
            let(:value) { 'In Processing' }
            it { should be_true }
          end
          context 'when the value is "In Transit"' do
            let(:value) { 'In Transit' }
            it { should be_true }
          end
        end
        describe '#unavailable?' do
          subject { status.unavailable? }
          it { should be_false }
          context 'when the value is "Unavailable"' do
            let(:value) { 'Unavailable' }
            it { should be_true }
          end
        end
        describe '#checked_out?' do
          subject { status.checked_out? }
          it { should be_false }
          context 'when the value is "05/31/14"' do
            let(:value) { '05/31/14' }
            it { should be_true }
          end
          context 'when the value is "Recalled due date: 05/31/14"' do
            let(:value) { 'Recalled due date: 05/31/14' }
            it { should be_true }
          end
        end
        describe '#recalled?' do
          subject { status.recalled? }
          it { should be_false }
          context 'when the value is "Recalled"' do
            let(:value) { 'Recalled' }
            it { should be_true }
          end
          context 'when the value is "Recalled due date: 05/31/14"' do
            let(:value) { 'Recalled due date: 05/31/14' }
            it { should be_true }
          end
        end
        describe '#reshelving?' do
          subject { status.reshelving? }
          it { should be_false }
          context 'when the value is "Reshelving"' do
            let(:value) { 'Reshelving' }
            it { should be_true }
          end
          context 'when the value is "Reshelving: with a note"' do
            let(:value) { 'Reshelving: with a note' }
            it { should be_true }
          end
        end
        describe '#requested?' do
          subject { status.requested? }
          it { should be_false }
          context 'when the value is "On Hold"' do
            let(:value) { 'On Hold' }
            it { should be_true }
          end
          context 'when the value is "Requested"' do
            let(:value) { 'Requested' }
            it { should be_true }
          end
          context 'when the value is "Requested: with a note"' do
            let(:value) { 'Requested: with a note' }
            it { should be_true }
          end
        end
        context 'when the item circulation status argument is not an Exlibris::Aleph::Item::CirculationStatus' do
          let(:circulation_status) { 'invalid' }
          it 'should raise an ArgumentError' do
            expect { subject }.to raise_error ArgumentError
          end
        end
      end
    end
  end
end
