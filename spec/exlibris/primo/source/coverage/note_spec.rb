require 'spec_helper'
module Exlibris
  module Primo
    module Source
      module Coverage
        describe Note do
          let(:value) { "this is a note" }
          subject(:note) { Note.new(value) }
          it { should be_a Note }
          describe '#value' do
            subject { note.value }
            it { should eq value }
          end
          describe '#to_s' do
            subject { note.to_s }
            it { should eq "Note: #{value}" }
          end
          context 'when initialized with no arguments' do
            it 'should raise an ArgumentError' do
              expect { Note.new }.to raise_error(ArgumentError)
            end
          end
        end
      end
    end
  end
end
