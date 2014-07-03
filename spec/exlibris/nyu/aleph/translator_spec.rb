require 'spec_helper'
module Exlibris
  module Nyu
    module Aleph
      describe Translator do
        let(:sub_library_code) { 'BOBST' }
        let(:collection_code) { 'MAIN' }
        let(:admin_library) { Exlibris::Aleph::AdminLibrary.new('NYU50') }
        let(:sub_library) do
          Exlibris::Aleph::SubLibrary.new(sub_library_code, 'NYU Bobst', admin_library)
        end
        let(:collection) do
          Exlibris::Aleph::Collection.new(collection_code, 'Main Collection', sub_library)
        end
        subject(:translator) do
          Translator.new(sub_library_code, collection_code)
        end
        it { should be_a Translator }
        describe '#sub_library_code' do
          subject { translator.sub_library_code }
          it { should eq sub_library_code }
        end
        describe '#collection_code' do
          subject { translator.collection_code }
          it { should eq collection_code }
        end
        describe '#admin_library' do
          subject { translator.admin_library }
          it { should be_an Exlibris::Aleph::AdminLibrary }
          it { should eq admin_library }
          context 'when there is not a match' do
            let(:sub_library_code) { 'NO_MATCH' }
            it { should be_nil }
          end
        end
        describe '#sub_library' do
          subject { translator.sub_library }
          it { should be_an Exlibris::Aleph::SubLibrary }
          it { should eq sub_library }
          context 'when there is not a match' do
            let(:sub_library_code) { 'NO_MATCH' }
            it { should be_nil }
          end
        end
        describe '#collection' do
          subject { translator.collection }
          it { should be_an Exlibris::Aleph::Collection }
          it { should eq collection }
          context 'when there is not a match for the sub library' do
            let(:sub_library_code) { 'NO_MATCH' }
            it { should be_nil }
          end
          context 'when there is a match for the sub library' do
            context 'but there is not a match for the collection' do
              let(:collection_code) { 'NO_MATCH' }
              it { should be_nil }
            end
          end
        end
      end
    end
  end
end
