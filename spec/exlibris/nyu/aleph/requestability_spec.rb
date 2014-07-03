require 'spec_helper'
module Exlibris
  module Nyu
    module Aleph
      describe Requestability do
        let(:request_attributes) { double }
        let(:requestable) { 'Y' }
        let(:photocopyable) { 'Y' }
        before do
          allow(request_attributes).to receive(:requestable).and_return(requestable)
          allow(request_attributes).to receive(:photocopyable).and_return(photocopyable)
          allow(request_attributes).to receive(:loanable)
          allow(request_attributes).to receive(:renewable)
          allow(request_attributes).to receive(:displayable)
          allow(request_attributes).to receive(:specific_item)
          allow(request_attributes).to receive(:limit_hold)
          allow(request_attributes).to receive(:recallable)
          allow(request_attributes).to receive(:rush_recallable)
          allow(request_attributes).to receive(:reloaning_limit)
          allow(request_attributes).to receive(:bookable)
          allow(request_attributes).to receive(:booking_hours)
        end
        let(:privileges) do
          Exlibris::Aleph::Item::CirculationPolicy::Privileges.new(request_attributes)
        end
        subject(:requestability) { Requestability.new(privileges) }
        it { should be_an Requestability }
        describe '#privileges' do
          subject { requestability.privileges }
          it { should eq privileges }
        end
        describe '#to_s' do
          subject { "#{requestability}" }
          context 'when the item always requestable' do
            let(:requestable) { 'C' }
            context 'and the item is ILL requestable' do
              let(:photocopyable) { 'Y' }
              it { should eq Requestability::YES }
            end
            context "and the item isn't ILL requestable" do
              let(:photocopyable) { 'Y' }
              it { should eq Requestability::YES }
            end
          end
          context "when the item's requestability depends on who is doing the requesting" do
            let(:requestable) { 'Y' }
            context 'and the item is ILL requestable' do
              let(:photocopyable) { 'Y' }
              it { should eq Requestability::YES }
            end
            context "and the item isn't ILL requestable" do
              let(:photocopyable) { 'N' }
              it { should eq Requestability::DEFERRED }
            end
          end
          context 'when the item is never requestable' do
            let(:requestable) { 'N' }
            context 'and the item is ILL requestable' do
              let(:photocopyable) { 'Y' }
              it { should eq Requestability::YES }
            end
            context "and the item isn't ILL requestable" do
              let(:photocopyable) { 'N' }
              it { should eq Requestability::NO }
            end
          end
        end
        context 'when initialized with a privileges argument which is not an Exlibris::Aleph::Item::CirculationPolicy::Privileges' do
          let(:privileges) { 'invalid' }
          it 'should raise an ArgumentError' do
            expect { subject }.to raise_error ArgumentError
          end
        end
      end
    end
  end
end
