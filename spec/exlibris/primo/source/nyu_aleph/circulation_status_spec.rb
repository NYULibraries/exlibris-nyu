require 'spec_helper'
module Exlibris
  module Primo
    module Source
      describe NyuAleph::CirculationStatus do
        let(:value) { "Available" }
        subject(:circulation_status) { NyuAleph::CirculationStatus.new(value) }
        it { should be_an NyuAleph::CirculationStatus }
        describe NyuAleph::CirculationStatus::AVAILABLE do
          subject { NyuAleph::CirculationStatus::AVAILABLE }
          it { should be_an Array }
          it { should eq ["On Shelf", "Available"] }
        end
        describe NyuAleph::CirculationStatus::OFFSITE do
          subject { NyuAleph::CirculationStatus::OFFSITE }
          it { should be_an Array }
          it { should eq ["Offsite Available"] }
        end
        describe NyuAleph::CirculationStatus::REQUESTED do
          subject { NyuAleph::CirculationStatus::REQUESTED }
          it { should be_an Array }
          it { should eq ["Requested", "On Hold"] }
        end
        describe NyuAleph::CirculationStatus::ILL do
          subject { NyuAleph::CirculationStatus::ILL }
          it { should be_an Array }
          it { should eq ["Request ILL"] }
        end
        describe NyuAleph::CirculationStatus::BILLED_AS_LOST do
          subject { NyuAleph::CirculationStatus::BILLED_AS_LOST }
          it { should be_an Array }
          it { should eq ["Billed as Lost", "Claimed Returned"] }
        end
        describe NyuAleph::CirculationStatus::UNAVAILABLE do
          subject { NyuAleph::CirculationStatus::UNAVAILABLE }
          it { should be_an Array }
          it { should eq ["Unavailable"] }
        end
        describe NyuAleph::CirculationStatus::PROCESSING do
          subject { NyuAleph::CirculationStatus::PROCESSING }
          it { should be_an Array }
          it { should eq ["In Processing", "In Transit"] }
        end
        describe NyuAleph::CirculationStatus::AFC do
          subject { NyuAleph::CirculationStatus::AFC }
          it { should be_an Array }
          it { should eq ["Ask at Avery Fisher Center"] }
        end
        describe NyuAleph::CirculationStatus::ARCHIVES do
          subject { NyuAleph::CirculationStatus::ARCHIVES }
          it { should be_an Array }
          it { should eq ["Ask at NYU Archives"] }
        end
        describe NyuAleph::CirculationStatus::FALES do
          subject { NyuAleph::CirculationStatus::FALES }
          it { should be_an Array }
          it { should eq ["Ask at Fales"] }
        end
        describe NyuAleph::CirculationStatus::TAMIMENT do
          subject { NyuAleph::CirculationStatus::TAMIMENT }
          it { should be_an Array }
          it { should eq ["Ask at Tamiment"] }
        end
        describe NyuAleph::CirculationStatus::REFERENCE do
          subject { NyuAleph::CirculationStatus::REFERENCE }
          it { should be_an Array }
          it { should eq ["Ask at Reference"] }
        end
        describe NyuAleph::CirculationStatus::EXHIBIT do
          subject { NyuAleph::CirculationStatus::EXHIBIT }
          it { should be_an Array }
          it { should eq ["On Exhibit"] }
        end
        describe '#value' do
          subject { circulation_status.value }
          it { should eq value }
        end
        describe '#code' do
          subject { circulation_status.code }
          NyuAleph::CirculationStatus::AVAILABLE.each do |status|
            context "when initialized with the value \"#{status}\"" do
              let(:value) { status }
              it { should eq :available }
            end
          end
          NyuAleph::CirculationStatus::OFFSITE.each do |status|
            context "when initialized with the value \"#{status}\"" do
              let(:value) { status }
              it { should eq :offsite }
            end
          end
          NyuAleph::CirculationStatus::REQUESTED.each do |status|
            context "when initialized with the value \"#{status}\"" do
              let(:value) { status }
              it { should eq :requested }
            end
          end
          NyuAleph::CirculationStatus::ILL.each do |status|
            context "when initialized with the value \"#{status}\"" do
              let(:value) { status }
              it { should eq :ill }
            end
          end
          context "when initialized with the value \"05/31/14\"" do
            let(:value) { "05/31/14" }
            it { should eq :checked_out }
          end
          context "when initialized with the value \"Recalled\"" do
            let(:value) { "Recalled" }
            it { should eq :recalled }
          end
          context "when initialized with the value \"Requested w/ some info\"" do
            let(:value) { "Requested w/ some info" }
            it { should eq :requested }
          end
          context "when initialized with the value \"Reshelving w/ some info\"" do
            let(:value) { "Reshelving w/ some info" }
            it { should eq :reshelving }
          end
        end
        describe '#checked_out?' do
          NyuAleph::CirculationStatus::STATUSES.each do |code, statuses|
            statuses.each do |status|
              context "when initialized with the value \"#{status}\"" do
                let(:value) { status }
                subject { circulation_status.checked_out? }
                it { should be_false }
              end
            end
          end
          context "when initialized with the value \"05/31/14\"" do
            let(:value) { "05/31/14" }
            subject { circulation_status.checked_out? }
            it { should be_true }
          end
        end
        describe '#available?' do
          NyuAleph::CirculationStatus::STATUSES.each do |code, statuses|
            statuses.each do |status|
              context "when initialized with the value \"#{status}\"" do
                let(:value) { status }
                subject { circulation_status.available? }
                if NyuAleph::CirculationStatus::AVAILABLE.include?(status)
                  it { should be_true }
                else
                  it { should be_false }
                end
              end
            end
          end
        end
        describe '#offsite?' do
          NyuAleph::CirculationStatus::STATUSES.each do |code, statuses|
            statuses.each do |status|
              context "when initialized with the value \"#{status}\"" do
                let(:value) { status }
                subject { circulation_status.offsite? }
                if NyuAleph::CirculationStatus::OFFSITE.include?(status)
                  it { should be_true }
                else
                  it { should be_false }
                end
              end
            end
          end
        end
        describe '#requested?' do
          NyuAleph::CirculationStatus::STATUSES.each do |code, statuses|
            statuses.each do |status|
              context "when initialized with the value \"#{status}\"" do
                let(:value) { status }
                subject { circulation_status.requested? }
                if NyuAleph::CirculationStatus::REQUESTED.include?(status)
                  it { should be_true }
                else
                  it { should be_false }
                end
              end
            end
          end
          context "when initialized with the value \"Requested w/ some info\"" do
            let(:value) { "Requested w/ some info" }
            subject { circulation_status.requested? }
            it { should be_true }
          end
        end
        describe '#ill?' do
          NyuAleph::CirculationStatus::STATUSES.each do |code, statuses|
            statuses.each do |status|
              context "when initialized with the value \"#{status}\"" do
                let(:value) { status }
                subject { circulation_status.ill? }
                if NyuAleph::CirculationStatus::ILL.include?(status)
                  it { should be_true }
                else
                  it { should be_false }
                end
              end
            end
          end
        end
        describe '#billed_as_lost?' do
          NyuAleph::CirculationStatus::STATUSES.each do |code, statuses|
            statuses.each do |status|
              context "when initialized with the value \"#{status}\"" do
                let(:value) { status }
                subject { circulation_status.billed_as_lost? }
                if NyuAleph::CirculationStatus::BILLED_AS_LOST.include?(status)
                  it { should be_true }
                else
                  it { should be_false }
                end
              end
            end
          end
        end
        describe '#unavailable?' do
          NyuAleph::CirculationStatus::STATUSES.each do |code, statuses|
            statuses.each do |status|
              context "when initialized with the value \"#{status}\"" do
                let(:value) { status }
                subject { circulation_status.unavailable? }
                if NyuAleph::CirculationStatus::UNAVAILABLE.include?(status)
                  it { should be_true }
                else
                  it { should be_false }
                end
              end
            end
          end
        end
        describe '#processing?' do
          NyuAleph::CirculationStatus::STATUSES.each do |code, statuses|
            statuses.each do |status|
              context "when initialized with the value \"#{status}\"" do
                let(:value) { status }
                subject { circulation_status.processing? }
                if NyuAleph::CirculationStatus::PROCESSING.include?(status)
                  it { should be_true }
                else
                  it { should be_false }
                end
              end
            end
          end
        end
        describe '#afc?' do
          NyuAleph::CirculationStatus::STATUSES.each do |code, statuses|
            statuses.each do |status|
              context "when initialized with the value \"#{status}\"" do
                let(:value) { status }
                subject { circulation_status.afc? }
                if NyuAleph::CirculationStatus::AFC.include?(status)
                  it { should be_true }
                else
                  it { should be_false }
                end
              end
            end
          end
        end
        describe '#archives?' do
          NyuAleph::CirculationStatus::STATUSES.each do |code, statuses|
            statuses.each do |status|
              context "when initialized with the value \"#{status}\"" do
                let(:value) { status }
                subject { circulation_status.archives? }
                if NyuAleph::CirculationStatus::ARCHIVES.include?(status)
                  it { should be_true }
                else
                  it { should be_false }
                end
              end
            end
          end
        end
        describe '#fales?' do
          NyuAleph::CirculationStatus::STATUSES.each do |code, statuses|
            statuses.each do |status|
              context "when initialized with the value \"#{status}\"" do
                let(:value) { status }
                subject { circulation_status.fales? }
                if NyuAleph::CirculationStatus::FALES.include?(status)
                  it { should be_true }
                else
                  it { should be_false }
                end
              end
            end
          end
        end
        describe '#tamiment?' do
          NyuAleph::CirculationStatus::STATUSES.each do |code, statuses|
            statuses.each do |status|
              context "when initialized with the value \"#{status}\"" do
                let(:value) { status }
                subject { circulation_status.tamiment? }
                if NyuAleph::CirculationStatus::TAMIMENT.include?(status)
                  it { should be_true }
                else
                  it { should be_false }
                end
              end
            end
          end
        end
        describe '#reference?' do
          NyuAleph::CirculationStatus::STATUSES.each do |code, statuses|
            statuses.each do |status|
              context "when initialized with the value \"#{status}\"" do
                let(:value) { status }
                subject { circulation_status.reference? }
                if NyuAleph::CirculationStatus::REFERENCE.include?(status)
                  it { should be_true }
                else
                  it { should be_false }
                end
              end
            end
          end
        end
        describe '#exhibit?' do
          NyuAleph::CirculationStatus::STATUSES.each do |code, statuses|
            statuses.each do |status|
              context "when initialized with the value \"#{status}\"" do
                let(:value) { status }
                subject { circulation_status.exhibit? }
                if NyuAleph::CirculationStatus::EXHIBIT.include?(status)
                  it { should be_true }
                else
                  it { should be_false }
                end
              end
            end
          end
        end
        describe '#recalled?' do
          NyuAleph::CirculationStatus::STATUSES.each do |code, statuses|
            statuses.each do |status|
              context "when initialized with the value \"#{status}\"" do
                let(:value) { status }
                subject { circulation_status.recalled? }
                it { should be_false }
              end
            end
          end
          context "when initialized with the value \"Recalled\"" do
            let(:value) { "Recalled" }
            subject { circulation_status.recalled? }
            it { should be_true }
          end
        end
        describe '#reshelving?' do
          NyuAleph::CirculationStatus::STATUSES.each do |code, statuses|
            statuses.each do |status|
              context "when initialized with the value \"#{status}\"" do
                let(:value) { status }
                subject { circulation_status.reshelving? }
                it { should be_false }
              end
            end
          end
          context "when initialized with the value \"Reshelving\"" do
            let(:value) { "Reshelving" }
            subject { circulation_status.reshelving? }
            it { should be_true }
          end
          context "when initialized with the value \"Reshelving w/ some info\"" do
            let(:value) { "Reshelving w/ some info" }
            subject { circulation_status.reshelving? }
            it { should be_true }
          end
        end
        describe '#due_date' do
          context 'when the item has been recalled' do
            let(:value) { "Recalled due date: 05/31/14" }
            subject { circulation_status.due_date }
            it { should eq "05/31/14" }
          end
          context 'when the item is checked out' do
            let(:value) { "05/31/14" }
            subject { circulation_status.due_date }
            it { should eq "05/31/14" }
          end
          context 'when the item is available' do
            let(:value) { "Available" }
            subject { circulation_status.due_date }
            it { should be_nil }
          end
        end
      end
    end
  end
end
