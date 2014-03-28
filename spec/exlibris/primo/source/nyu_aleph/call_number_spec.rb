require 'spec_helper'
module Exlibris
  module Primo
    module Source
      describe NyuAleph::CallNumber do
        let(:classification) { }
        let(:description) {  }
        subject(:call_number) { NyuAleph::CallNumber.new(classification, description) }
        it { should be_a NyuAleph::CallNumber}
        describe '#classification' do
          subject { call_number.classification }
          it { should eq classification }
        end
        describe '#description' do
          subject { call_number.description }
          it { should eq description }
        end
        describe '#to_s' do
          it 'should work'
        end
      end
    end
  end
end
