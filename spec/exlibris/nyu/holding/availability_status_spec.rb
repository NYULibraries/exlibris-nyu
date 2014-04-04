require 'spec_helper'
module Exlibris
  module Nyu
    module Holding
      describe AvailabilityStatus do
        let(:circulation_status_value) { 'On Shelf' }
        let(:circulation_status) { CirculationStatus.new(circulation_status_value) }
        subject(:availability_status) { AvailabilityStatus.new(circulation_status) }
        it { should be_an AvailabilityStatus }
        describe '#code' do
          subject { availability_status.code }
          context 'when the circulation status is nil' do
            let(:circulation_status_value) { nil }
            it { should be_nil }
          end
          context 'when the circulation status is an empty string' do
            let(:circulation_status_value) { "" }
            it { should be_nil }
          end
          context 'when the circulation status is a string with only spaces' do
            let(:circulation_status_value) { "   " }
            it { should be_nil }
          end
          context 'when the circulation status is "On Shelf"' do
            let(:circulation_status_value) { 'On Shelf' }
            it { should eq 'available' }
          end
          context 'when the circulation status is "Available"' do
            let(:circulation_status_value) { 'Available' }
            it { should eq 'available' }
          end
          context 'when the circulation status is "In Processing"' do
            let(:circulation_status_value) { 'In Processing' }
            it { should eq 'processing' }
          end
          context 'when the circulation status is "In Transit"' do
            let(:circulation_status_value) { 'In Transit' }
            it { should eq 'processing' }
          end
          context 'when the circulation status is "03/31/2014"' do
            let(:circulation_status_value) { '03/31/2014' }
            it { should eq 'checked_out' }
          end
          context 'when the circulation status is "03/31/2014; Requested"' do
            let(:circulation_status_value) { '03/31/14; Requested' }
            it { should eq 'checked_out' }
          end
          context 'when the circulation status is "Requested"' do
            let(:circulation_status_value) { 'Requested' }
            it { should eq 'requested' }
          end
          context 'when the circulation status is "Requested; On Hold"' do
            let(:circulation_status_value) { 'Requested; On Hold' }
            it { should eq 'requested' }
          end
          context 'when the circulation status is "Billed as Lost"' do
            let(:circulation_status_value) { 'Billed as Lost' }
            it { should eq 'billed_as_lost' }
          end
          context 'when the circulation status is "Claimed Returned"' do
            let(:circulation_status_value) { 'Claimed Returned' }
            it { should eq 'billed_as_lost' }
          end
        end
        describe '#value' do
          subject { availability_status.value }
          context 'when the circulation status is nil' do
            let(:circulation_status_value) { nil }
            it { should be_nil }
          end
          context 'when the circulation status is an empty string' do
            let(:circulation_status_value) { "" }
            it { should be_nil }
          end
          context 'when the circulation status is a string with only spaces' do
            let(:circulation_status_value) { "   " }
            it { should be_nil }
          end
          context 'when the circulation status is "On Shelf"' do
            let(:circulation_status_value) { 'On Shelf' }
            it { should eq 'Available' }
          end
          context 'when the circulation status is "Available"' do
            let(:circulation_status_value) { 'Available' }
            it { should eq 'Available' }
          end
          context 'when the circulation status is "In Processing"' do
            let(:circulation_status_value) { 'In Processing' }
            it { should eq 'In Processing' }
          end
          context 'when the circulation status is "In Transit"' do
            let(:circulation_status_value) { 'In Transit' }
            it { should eq 'In Processing' }
          end
          context 'when the circulation status is "03/31/2014"' do
            let(:circulation_status_value) { '03/31/14' }
            it { should eq 'Due: 03/31/14' }
          end
          context 'when the circulation status is "03/31/2014; Requested"' do
            let(:circulation_status_value) { '03/31/14; Requested' }
            it { should eq 'Due: 03/31/14; Requested' }
          end
          context 'when the circulation status is "Requested"' do
            let(:circulation_status_value) { 'Requested' }
            it { should eq 'Requested' }
          end
          context 'when the circulation status is "On Hold"' do
            let(:circulation_status_value) { 'On Hold' }
            it { should eq 'On Hold' }
          end
          context 'when the circulation status is "Requested; On Hold"' do
            let(:circulation_status_value) { 'Requested; On Hold' }
            it { should eq 'Requested; On Hold' }
          end
          context 'when the circulation status is "Unmapped Value"' do
            let(:circulation_status_value) { 'Requested; On Hold' }
            it { should eq 'Requested; On Hold' }
          end
          context 'when the circulation status is "Billed as Lost"' do
            let(:circulation_status_value) { 'Billed as Lost' }
            it { should eq 'Request ILL' }
          end
          context 'when the circulation status is "Claimed Returned"' do
            let(:circulation_status_value) { 'Claimed Returned' }
            it { should eq 'Request ILL' }
          end
        end
      end
    end
  end
end
