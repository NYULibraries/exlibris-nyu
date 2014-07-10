require 'spec_helper'
module Exlibris
  module Nyu
    module Aleph
      describe SubLibraryFinder do
        let(:sub_library_code) { 'BOBST' }
        let(:admin_library) { Exlibris::Aleph::AdminLibrary.new('NYU50') }
        let(:sub_library) do
          Exlibris::Aleph::SubLibrary.new(sub_library_code, 'NYU Bobst', admin_library)
        end
        subject(:sub_library_finder) do
          SubLibraryFinder.new(sub_library_code)
        end
        it { should be_a SubLibraryFinder }
        describe '#sub_library_code' do
          subject { sub_library_finder.sub_library_code }
          it { should eq sub_library_code }
        end
        describe '#sub_library' do
          subject { sub_library_finder.sub_library }
          it { should be_an Exlibris::Aleph::SubLibrary }
          it { should eq sub_library }
          context 'when there is not a match for the sub library code' do
            let(:sub_library_code) { 'NO_MATCH' }
            it { should be_nil }
          end
        end
      end
    end
  end
end
