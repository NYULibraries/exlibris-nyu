require 'spec_helper'
module Exlibris
  module Primo
    module Source
      describe NyuAleph::CallNumber do
        let(:classification) { "classification" }
        let(:description) { "description" }
        subject(:call_number) { NyuAleph::CallNumber.new(classification, description) }
        it { should be_a NyuAleph::CallNumber}
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
          context 'when initialized without a classification' do
            let(:classification) { nil }
            context 'and initialized with a description' do
              let(:description) { "description" }
              it { should eq "(description)"}
            end
            context 'and initialized without a description' do
              let(:description) { nil }
              it { should be_empty }
            end
          end
        end
      end
    end
  end
end
