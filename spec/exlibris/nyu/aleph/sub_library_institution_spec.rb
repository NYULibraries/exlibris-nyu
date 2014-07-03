require 'spec_helper'
module Exlibris
  module Nyu
    module Aleph
      describe SubLibraryInstitution do
        let(:admin_library) { Exlibris::Aleph::AdminLibrary.new('NYU50') }
        let(:sub_library) do
          Exlibris::Aleph::SubLibrary.new('BOBST', 'NYU Bobst', admin_library)
        end
        subject(:sub_library_institution) { SubLibraryInstitution.new(sub_library) }
        describe '#sub_library' do
          subject { sub_library_institution.sub_library }
          it { should eq sub_library }
        end
        describe '#institution' do
          subject { sub_library_institution.institution }
          it { should eq "NYU" }
          context 'when there is not a match' do
            let(:sub_library) do
              Exlibris::Aleph::SubLibrary.new('NO_MATCH', 'No Match', admin_library)
            end
            it { should be_nil }
          end
        end
        context 'when initialized with a sub library argument that is not an Exlibris::Aleph::SubLibrary' do
          let(:sub_library) { 'invalid' }
          it 'should raise an ArgumentError' do
            expect { subject }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end
end
