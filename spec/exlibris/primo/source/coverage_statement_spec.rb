require 'spec_helper'
module Exlibris
  module Primo
    module Source
      describe CoverageStatement do
        let(:textual_holding) { "This is a textual holding" }
        let(:textual_holdings) { [textual_holding] }
        let(:note) { "This is a note" }
        let(:notes) { [note] }
        let(:args) { [textual_holdings, notes] }
        subject(:coverage_statement) { CoverageStatement.new(*args) }
        it { should be_an CoverageStatement }
        describe '#textual_holdings' do
          subject { coverage_statement.textual_holdings }
          it { should eq textual_holdings }
        end
        describe '#notes' do
          subject { coverage_statement.notes }
          it { should eq notes }
        end
        describe '#to_a' do
          subject { coverage_statement.to_a }
          it { should be_an Array }
          it 'should have 2 elements' do
            expect(subject.size).to be 2
          end
        end
        context 'when initialized without any arguments' do
          subject { CoverageStatement.new }
          it 'should raise an ArgumentError' do
            expect { subject }.to raise_error(ArgumentError)
          end
        end
        context 'when initialized with a textual holdings argument' do
          let(:args) { [] }
          context 'but the argument is not nil or an Array' do
            before { args << "" }
            it 'should raise an ArgumentError' do
              expect { subject }.to raise_error(ArgumentError)
            end
          end
          context 'and the textual holdings argument is nil' do
            before { args << nil }
            context 'but there is no notes argument' do
              it 'should raise an ArgumentError' do
                expect { subject }.to raise_error(ArgumentError)
              end
            end
            context 'and there is a notes argument' do
              context 'but the notes argument is not an Array' do
                before { args << "" }
                it 'should raise an ArgumentError' do
                  expect { subject }.to raise_error(ArgumentError)
                end
              end
              context 'and the notes argument is an Array' do
                context 'but the Array is empty' do
                  before { args << [] }
                  it 'should raise an ArgumentError' do
                    expect { subject }.to raise_error(ArgumentError)
                  end
                end
                context 'and the Array is not empty' do
                  before { args << notes }
                  it 'should not raise an ArgumentError' do
                    expect { subject }.not_to raise_error
                  end
                end
              end
            end
          end
          context 'and the textual holdings argument is an Array' do
            context 'and the Array is empty' do
              before { args << [] }
              context 'but there is no notes argument' do
                it 'should raise an ArgumentError' do
                  expect { subject }.to raise_error(ArgumentError)
                end
              end
              context 'and there is a notes argument' do
                context 'but the notes argument is not an Array' do
                  before { args << "" }
                  it 'should raise an ArgumentError' do
                    expect { subject }.to raise_error(ArgumentError)
                  end
                end
                context 'and the notes argument is an Array' do
                  context 'but the Array is empty' do
                    before { args << [] }
                    it 'should raise an ArgumentError' do
                      expect { subject }.to raise_error(ArgumentError)
                    end
                  end
                  context 'and the Array is not empty' do
                    before { args << notes }
                    it 'should not raise an ArgumentError' do
                      expect { subject }.not_to raise_error
                    end
                  end
                end
              end
            end
            context 'and the Array is not empty' do
              before { args << textual_holdings }
              it 'should not raise an ArgumentError' do
                expect { subject }.not_to raise_error
              end
            end
          end
        end
      end
    end
  end
end
