require 'spec_helper'
module Exlibris
  module Nyu
    class Holding
      describe SubLibraryInstitution do
        let(:sub_library) { "BOBST" }
        subject(:sub_library_institution) { SubLibraryInstitution.new(sub_library) }
        describe '#sub_library' do
          subject { sub_library_institution.sub_library }
          it { should eq sub_library }
        end
        describe '#institution' do
          subject { sub_library_institution.institution }
          it { should eq "NYU" }
        end
        context 'when initialized without any arguments' do
          it 'should raise an ArgumentError' do
            expect { SubLibraryInstitution.new }.to raise_error(ArgumentError)
          end
        end
      end
    end
  end
end
