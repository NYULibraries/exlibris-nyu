require 'spec_helper'
module Exlibris
  module Primo
    module Source
      describe CoverageStatement do
        let(:aleph_helper) { Exlibris::Aleph::TabHelper.instance() }
        let(:adm_library) { "New York" }
        let(:sub_library) { "Sub Library" }
        let(:textual_holding) { "These are the textual holdings" }
        let(:textual_holdings) { [textual_holding] }
        let(:note) { "This is a note" }
        let(:notes) { [note] }
        let(:attributes) do
          {
            adm_library: adm_library,
            sub_library: sub_library,
            textual_holdings: textual_holdings,
            notes: notes
          }
        end
        subject(:coverage_statement) { CoverageStatement.new(attributes) }
        it { should be_an CoverageStatement }
        describe '#adm_library' do
          subject { coverage_statement.adm_library }
          it { should eq adm_library }
        end
        describe '#sub_library' do
          subject { coverage_statement.sub_library }
          it { should eq sub_library }
        end
        describe '#textual_holdings' do
          subject { coverage_statement.textual_holdings }
          it { should eq textual_holdings }
        end
        describe '#notes' do
          subject { coverage_statement.notes }
          it { should eq notes }
        end
        context 'when initialized without any attributes' do
          subject { CoverageStatement.new }
          it 'should raise an ArgumentError' do
            expect { subject }.to raise_error(ArgumentError)
          end
        end
        context 'when initialized with attributes' do
          subject { CoverageStatement.new(attributes) }
          context 'but the attributes argument is not a Hash' do
            let(:attributes) { "" }
            it 'should raise an ArgumentError' do
              expect { subject }.to raise_error(ArgumentError)
            end
          end
          context 'and the attributes argument is a Hash' do
            let(:attributes) { Hash.new }
            context 'but the attributes do not have an ADM library' do
              it 'should raise an ArgumentError' do
                expect { subject }.to raise_error(ArgumentError)
              end
            end
            context 'and the attributes do have an ADM library' do
              before { attributes[:adm_library] = adm_library }
              context 'but the attributes do not have a sub library' do
                it 'should raise an ArgumentError' do
                  expect { subject }.to raise_error(ArgumentError)
                end
              end
              context 'and the attributes do have a sub library' do
                before { attributes[:sub_library] = sub_library }
                context 'but the attributes do not have textual holdings' do
                  context 'nor do the attributes have notes' do
                    it 'should raise an ArgumentError' do
                      expect { subject }.to raise_error(ArgumentError)
                    end
                  end
                end
                context 'and the attributes have textual holdings' do
                  before { attributes[:textual_holdings] = textual_holdings }
                  context 'but they do not have notes' do
                    it 'should not raise an error' do
                      expect { subject }.not_to raise_error
                    end
                  end
                end
                context 'and the attributes do have notes' do
                  before { attributes[:notes] = notes }
                  context 'but the attributes do not have textual holdings' do
                    it 'should not raise an error' do
                      expect { subject }.not_to raise_error
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
