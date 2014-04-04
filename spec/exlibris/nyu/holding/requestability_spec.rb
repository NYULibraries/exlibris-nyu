require 'spec_helper'
module Exlibris
  module Nyu
    module Holding
      describe Requestability do
        let(:item_permissions) do
          { hold_request: 'Y', photocopy_request: 'Y' }
        end
        subject(:requestability) { Requestability.new(item_permissions) }
        it { should be_an Requestability }
        describe '#value' do
          subject { requestability.value }
          context 'when the item always requestable' do
            context 'and the item is ILL requestable' do
              let(:item_permissions) do
                { hold_request: 'C', photocopy_request: 'Y' }
              end
              it { should eq Requestability::YES }
            end
            context "and the item isn't ILL requestable" do
              let(:item_permissions) do
                { hold_request: 'C', photocopy_request: 'N' }
              end
              it { should eq Requestability::YES }
            end
          end
          context "when the item's requestability depends on who is doing the requesting" do
            context 'and the item is ILL requestable' do
              let(:item_permissions) do
                { hold_request: 'Y', photocopy_request: 'Y' }
              end
              it { should eq Requestability::YES }
            end
            context "and the item isn't ILL requestable" do
              let(:item_permissions) do
                { hold_request: 'Y', photocopy_request: 'N' }
              end
              it { should eq Requestability::DEFERRED }
            end
          end
          context 'when the item is never requestable' do
            context 'and the item is ILL requestable' do
              let(:item_permissions) do
                { hold_request: 'N', photocopy_request: 'Y' }
              end
              it { should eq Requestability::YES }
            end
            context "and the item isn't ILL requestable" do
              let(:item_permissions) do
                { hold_request: 'N', photocopy_request: 'N' }
              end
              it { should eq Requestability::NO }
            end
          end
        end
      end
    end
  end
end
