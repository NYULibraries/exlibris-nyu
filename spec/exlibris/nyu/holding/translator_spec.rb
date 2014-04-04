require 'spec_helper'
module Exlibris
  module Nyu
    module Holding
      describe Translator do
        let(:adm_library_code) { "NYU50" }
        let(:sub_library_code) { "BOBST" }
        let(:collection_code) { "MAIN" }
        let(:item_status_code) { "01" }
        let(:item_process_status_code) { "DP" }
        let(:attributes) do
          {
            adm_library_code: adm_library_code,
            sub_library_code: sub_library_code,
            collection_code: collection_code,
            item_status_code: item_status_code,
            item_process_status_code: item_process_status_code
          }
        end
        subject(:translator) { Translator.new(attributes) }
        it { should be_an Translator }
        describe '#adm_library_code' do
          subject { translator.adm_library_code }
          context 'when initialized with an ADM library code' do
            it { should eq "nyu50"}
          end
          context 'when initialized without an ADM library code' do
            let(:adm_library_code) { nil }
            let(:sub_library_code) { "BOBST" }
            it { should eq "nyu50" }
          end
        end
        describe '#sub_library_code' do
          subject { translator.sub_library_code }
          it { should eq "BOBST"}
        end
        describe '#sub_library' do
          subject { translator.sub_library }
          context 'when there is a match' do
            let(:sub_library_code) { "BOBST" }
            it { should eq 'NYU Bobst'}
          end
          context 'when there is not a match' do
            let(:sub_library_code) { "NO_MATCH" }
            it { should be_nil }
          end
        end
        describe '#collection_code' do
          subject { translator.collection_code }
          it { should eq "MAIN"}
        end
        describe '#collection' do
          subject { translator.collection }
          context 'when there is a match' do
            let(:collection_code) { "MAIN" }
            it { should eq 'Main Collection'}
          end
          context 'when there is not a match' do
            let(:collection_code) { "NO_MATCH" }
            it { should be_nil }
          end
        end
        describe '#item_status_code' do
          subject { translator.item_status_code }
          it { should eq "01"}
        end
        describe '#item_process_status_code' do
          subject { translator.item_process_status_code }
          it { should eq "DP"}
        end
        describe '#item_status' do
          subject { translator.item_status }
          context 'when there is a match' do
            let(:item_process_status_code) { "DP" }
            it { should eq 'Offsite Available'}
          end
          context 'when there is not a match' do
            let(:item_process_status_code) { "NO_MATCH" }
            it { should be_nil }
          end
        end
        describe '#item_permissions' do
          subject { translator.item_permissions }
          context 'when there is a match' do
            let(:item_process_status_code) { "DP" }
            it { should be_a Hash }
            it { should_not be_empty }
          end
          context 'when there is not a match' do
            let(:item_process_status_code) { "NO_MATCH" }
            it { should be_nil }
          end
        end
      end
    end
  end
end
