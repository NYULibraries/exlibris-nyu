require 'spec_helper'
module Exlibris
  module Nyu
    module Aleph
      describe CallNumber do
        let(:classification) { "classification" }
        let(:description) { "description" }
        let(:item_call_number) { Exlibris::Aleph::Item::CallNumber.new(classification, description)}
        subject(:call_number) { CallNumber.new(item_call_number) }
        it { should be_a CallNumber}
        describe '#classification' do
          subject { call_number.classification }
          it { should eq "classification" }
        end
        describe '#description' do
          subject { call_number.description }
          it { should eq "description" }
        end
        describe '#to_s' do
          subject { call_number.to_s }
          context 'when initialized with a classification' do
            let(:classification) { "classification" }
            context 'and initialized with a description' do
              let(:description) { "description" }
              it { should eq "(classification description)" }
              context 'and the classification has a &nbsp;' do
                let(:classification) { "classification&nbsp;classification" }
                it { should eq "(classification classification description)" }
              end
              context 'and the classification has some MARC' do
                let(:classification) { "classification$$iclassification$$h" }
                it { should eq "(classification classification description)" }
              end
              context 'and the description has a &nbsp;' do
                let(:description) { "description&nbsp;description" }
                it { should eq "(classification description description)" }
              end
            end
            context 'and initialized without a description' do
              let(:description) { nil }
              it { should eq "(classification)"}
            end
          end
          context 'when initialized with an item call number argument which is not an Exlibris::Aleph::Item::CallNumber' do
            let(:item_call_number) { 'invalid' }
            it 'should raise an ArgumentError' do
              expect { subject }.to raise_error ArgumentError
            end
          end
        end
      end
    end
  end
end
