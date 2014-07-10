require 'spec_helper'
module Exlibris
  module Nyu
    module Aleph
      describe CollectionFinder do
        let(:sub_library_code) { 'BOBST' }
        let(:collection_code) { 'MAIN' }
        let(:collection_display) { 'Main Collection' }
        let(:collection_code_or_display) { collection_code }
        let(:admin_library) { Exlibris::Aleph::AdminLibrary.new('NYU50') }
        let(:sub_library) do
          Exlibris::Aleph::SubLibrary.new(sub_library_code, 'NYU Bobst', admin_library)
        end
        let(:collection) do
          Exlibris::Aleph::Collection.new(collection_code, collection_display, sub_library)
        end
        subject(:collection_finder) do
          CollectionFinder.new(sub_library_code, collection_code_or_display)
        end
        it { should be_a CollectionFinder }
        describe '#sub_library_code' do
          subject { collection_finder.sub_library_code }
          it { should eq sub_library_code }
        end
        describe '#collection_code_or_display' do
          subject { collection_finder.collection_code_or_display }
        end
        describe '#collection' do
          subject { collection_finder.collection }
          context 'when the collection_code_or_display is a code' do
            let(:collection_code_or_display) { collection_code }
            it { should be_an Exlibris::Aleph::Collection }
            it { should eq collection }
          end
          context 'when the collection_code_or_display is a display' do
            let(:collection_code_or_display) { collection_display }
            it { should be_an Exlibris::Aleph::Collection }
            it { should eq collection }
          end
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
