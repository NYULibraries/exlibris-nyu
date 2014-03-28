require 'spec_helper'
module Exlibris
  module Primo
    module Source
      describe NyuAleph::AvailabilityStatus do
        let(:circulation_status) { 'On Shelf' }
        subject(:availability_status) { NyuAleph::AvailabilityStatus.new(circulation_status) }
        it { should be_an NyuAleph::AvailabilityStatus }
        describe '#code' do
          subject { availability_status.code }
          it 'should work'
        end
        describe '#value' do
          subject { availability_status.value }
          it 'should work'
        end
      end
    end
  end
end
