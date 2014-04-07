require 'spec_helper'
module Exlibris
  module Nyu
    describe Holding::CirculationStatus do
      let(:value) { 'Available' }
      subject(:circulation_status) { Holding::CirculationStatus.new(value) }
      it { should be_an Holding::CirculationStatus }
      describe Holding::CirculationStatus::AVAILABLE do
        subject { Holding::CirculationStatus::AVAILABLE }
        it { should be_an Array }
        it { should eq ['On Shelf', 'Available'] }
      end
      describe Holding::CirculationStatus::OFFSITE do
        subject { Holding::CirculationStatus::OFFSITE }
        it { should be_an Array }
        it { should eq ['Offsite Available'] }
      end
      describe Holding::CirculationStatus::REQUESTED do
        subject { Holding::CirculationStatus::REQUESTED }
        it { should be_an Array }
        it { should eq ['Requested', 'On Hold'] }
      end
      describe Holding::CirculationStatus::BILLED_AS_LOST do
        subject { Holding::CirculationStatus::BILLED_AS_LOST }
        it { should be_an Array }
        it { should eq ['Billed as Lost', 'Claimed Returned'] }
      end
      describe Holding::CirculationStatus::UNAVAILABLE do
        subject { Holding::CirculationStatus::UNAVAILABLE }
        it { should be_an Array }
        it { should eq ['Unavailable'] }
      end
      describe Holding::CirculationStatus::PROCESSING do
        subject { Holding::CirculationStatus::PROCESSING }
        it { should be_an Array }
        it { should eq ['In Processing', 'In Transit'] }
      end
      describe '#value' do
        subject { circulation_status.value }
        it { should eq value }
      end
      describe '#code' do
        subject { circulation_status.code }
        Holding::CirculationStatus::AVAILABLE.each do |status|
          context "when initialized with the value \"#{status}\"" do
            let(:value) { status }
            it { should eq :available }
          end
        end
        Holding::CirculationStatus::REQUESTED.each do |status|
          context "when initialized with the value \"#{status}\"" do
            let(:value) { status }
            it { should eq :requested }
          end
        end
        context 'when initialized with the value "05/31/14"' do
          let(:value) { '05/31/14' }
          it { should eq :checked_out }
        end
        context 'when initialized with the value "Recalled"' do
          let(:value) { 'Recalled' }
          it { should eq :recalled }
        end
        context 'when initialized with the value "Requested w/ some info"' do
          let(:value) { 'Requested w/ some info' }
          it { should eq :requested }
        end
        context 'when initialized with the value "On Hold"' do
          let(:value) { 'On Hold' }
          it { should eq :requested }
        end
        context 'when initialized with the value "Reshelving w/ some info"' do
          let(:value) { 'Reshelving w/ some info' }
          it { should eq :reshelving }
        end
        context 'when initialized with nil' do
          let(:value) { nil }
          it { should eq nil }
        end
        context 'when initialized with an empty string' do
          let(:value) { "" }
          it { should be_nil }
        end
        context 'when initialized with a string with only spaces' do
          let(:value) { "  " }
          it { should be_nil }
        end
      end
      describe '#checked_out?' do
        Holding::CirculationStatus::STATUSES.each do |code, statuses|
          statuses.each do |status|
            context "when initialized with the value \"#{status}\"" do
              let(:value) { status }
              subject { circulation_status.checked_out? }
              it { should be_false }
            end
          end
        end
        context 'when initialized with the value "05/31/14"' do
          let(:value) { "05/31/14" }
          subject { circulation_status.checked_out? }
          it { should be_true }
        end
      end
      describe '#available?' do
        Holding::CirculationStatus::STATUSES.each do |code, statuses|
          statuses.each do |status|
            context "when initialized with the value \"#{status}\"" do
              let(:value) { status }
              subject { circulation_status.available? }
              if Holding::CirculationStatus::AVAILABLE.include?(status)
                it { should be_true }
              else
                it { should be_false }
              end
            end
          end
        end
      end
      describe '#requested?' do
        Holding::CirculationStatus::STATUSES.each do |code, statuses|
          statuses.each do |status|
            context "when initialized with the value \"#{status}\"" do
              let(:value) { status }
              subject { circulation_status.requested? }
              if Holding::CirculationStatus::REQUESTED.include?(status)
                it { should be_true }
              else
                it { should be_false }
              end
            end
          end
        end
        context 'when initialized with the value "Requested w/ some info"' do
          let(:value) { 'Requested w/ some info' }
          subject { circulation_status.requested? }
          it { should be_true }
        end
      end
      describe '#billed_as_lost?' do
        Holding::CirculationStatus::STATUSES.each do |code, statuses|
          statuses.each do |status|
            context "when initialized with the value \"#{status}\"" do
              let(:value) { status }
              subject { circulation_status.billed_as_lost? }
              if Holding::CirculationStatus::BILLED_AS_LOST.include?(status)
                it { should be_true }
              else
                it { should be_false }
              end
            end
          end
        end
      end
      describe '#unavailable?' do
        Holding::CirculationStatus::STATUSES.each do |code, statuses|
          statuses.each do |status|
            context "when initialized with the value \"#{status}\"" do
              let(:value) { status }
              subject { circulation_status.unavailable? }
              if Holding::CirculationStatus::UNAVAILABLE.include?(status)
                it { should be_true }
              else
                it { should be_false }
              end
            end
          end
        end
      end
      describe '#processing?' do
        Holding::CirculationStatus::STATUSES.each do |code, statuses|
          statuses.each do |status|
            context "when initialized with the value \"#{status}\"" do
              let(:value) { status }
              subject { circulation_status.processing? }
              if Holding::CirculationStatus::PROCESSING.include?(status)
                it { should be_true }
              else
                it { should be_false }
              end
            end
          end
        end
      end
      describe '#recalled?' do
        Holding::CirculationStatus::STATUSES.each do |code, statuses|
          statuses.each do |status|
            context "when initialized with the value \"#{status}\"" do
              let(:value) { status }
              subject { circulation_status.recalled? }
              it { should be_false }
            end
          end
        end
        context 'when initialized with the value "Recalled"' do
          let(:value) { 'Recalled' }
          subject { circulation_status.recalled? }
          it { should be_true }
        end
      end
      describe '#reshelving?' do
        Holding::CirculationStatus::STATUSES.each do |code, statuses|
          statuses.each do |status|
            context "when initialized with the value \"#{status}\"" do
              let(:value) { status }
              subject { circulation_status.reshelving? }
              it { should be_false }
            end
          end
        end
        context 'when initialized with the value "Reshelving"' do
          let(:value) { "Reshelving" }
          subject { circulation_status.reshelving? }
          it { should be_true }
        end
        context 'when initialized with the value "Reshelving w/ some info"' do
          let(:value) { 'Reshelving w/ some info' }
          subject { circulation_status.reshelving? }
          it { should be_true }
        end
      end
      describe '#due_date' do
        context 'when the item has been recalled' do
          let(:value) { 'Recalled due date: 05/31/14' }
          subject { circulation_status.due_date }
          it { should eq '05/31/14' }
        end
        context 'when the item is checked out' do
          let(:value) { '05/31/14' }
          subject { circulation_status.due_date }
          it { should eq '05/31/14' }
        end
        context 'when the item is available' do
          let(:value) { 'Available' }
          subject { circulation_status.due_date }
          it { should be_nil }
        end
      end
    end
  end
end
