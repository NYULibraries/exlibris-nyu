require 'spec_helper'
module Exlibris
  module Nyu
    module Coverage
      describe Statement do
        let(:bib_library) { "NYU01" }
        let(:record_id) { "002893728" }
        let(:aleph_record) { Exlibris::Aleph::Record.new(bib_library: bib_library, record_id: record_id) }
        let(:textual_holding) { "This is a textual holding" }
        let(:textual_holdings) { [textual_holding] }
        let(:note) { "This is a note" }
        let(:notes) { [note] }
        let(:args) { [textual_holdings, notes] }
        subject(:statement) { Statement.new(*args) }
        it { should be_a Statement }
        describe 'MARC initialization helpers', vcr: { cassette_name: "vogue" } do
          describe '.from_marc_bib' do
            let(:sub_library) { "BOBST" }
            let(:marc_bib) { aleph_record.bib }
            subject(:statement) { Statement.from_marc_bib(sub_library, marc_bib) }
            it { should be_a Statement }
            describe '#textual_holdings' do
              subject { statement.textual_holdings }
              it { should be_an Array }
              it 'should have TextualHoldings as the elements' do
                expect(subject.size).to be > 0
                subject.each do |textual_holding|
                  expect(textual_holding).to be_a TextualHolding
                end
              end
            end
          end
          describe '.from_marc_holdings', vcr: { cassette_name: "vogue" } do
            let(:sub_library) { "TNSGI" }
            let(:marc_holdings) { aleph_record.holdings }
            subject { Statement.from_marc_holdings(sub_library, marc_holdings) }
            it { should be_a Statement }
          end
        end
        describe '#textual_holdings' do
          subject { statement.textual_holdings }
          it { should be_an Array }
          it { should eq textual_holdings }
        end
        describe '#notes' do
          subject { statement.notes }
          it { should be_an Array }
          it { should eq notes }
        end
        describe '#to_a' do
          subject { statement.to_a }
          it { should be_an Array }
          it 'should have 2 elements' do
            expect(subject.size).to be 2
          end
        end
        context 'when initialized without any arguments' do
          subject { Statement.new }
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
