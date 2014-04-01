require 'spec_helper'
# Vogue: nyu_aleph002893728
# Visionaire: nyu_aleph001951476
module Exlibris
  module Primo
    module Source
      describe NyuAleph do
        let(:adm_library_code) { 'ADM50' }
        let(:sub_library_code) { 'SUBLIB' }
        let(:collection_code) { 'COLL' }
        let(:circulation_status) { 'On Shelf' }
        let(:availability_status_code) { 'available' }
        let(:item_status_code) { '01' }
        let(:item_process_status_code) { nil }
        let(:availability_status_code) { 'available' }
        let(:from_aleph) { true }
        let(:source_data) do
          { from_aleph: from_aleph}
        end
        let(:attributes) do
          {
            source_id: 'nyu_aleph',
            original_source_id: 'NYU01',
            adm_library_code: adm_library_code,
            sub_library_code: sub_library_code,
            collection_code: collection_code,
            circulation_status: circulation_status,
            availability_status_code: availability_status_code,
            item_status_code: item_status_code,
            item_process_status_code: item_process_status_code,
            source_data: source_data
          }
        end
        subject(:nyu_aleph) { NyuAleph.new(attributes) }
        it { should be_an NyuAleph }
        it { should be_an Aleph }
        it { should be_an Exlibris::Primo::Holding }
        describe '#source_config' do
          subject { nyu_aleph.source_config }
          it { should be_a Hash }
        end
        describe '#adm_library_code' do
          subject { nyu_aleph.adm_library_code }
          it { should eq adm_library_code }
        end
        describe '#sub_library_code' do
          subject { nyu_aleph.sub_library_code }
          it { should eq sub_library_code }
        end
        describe '#collection_code' do
          subject { nyu_aleph.collection_code }
          it { should eq collection_code }
        end
        describe '#institution_code' do
          before { attributes[:institution_code] = institution_code }
          subject { nyu_aleph.institution_code }
          context 'when there is not an institution code' do
            let(:institution_code) { nil }
            context 'and there is a sub library code' do
              context 'and it maps to an institution in the source config' do
                let(:sub_library_code) { 'BOBST' }
                it 'should get the institution from the sub library code' do
                  expect(subject).to eq 'NYU'
                end
              end
              context 'but it does not map to an institution in the source config' do
                let(:sub_library_code) { 'NOT_MAPPED' }
                it 'should get the institution from the sub library code' do
                  expect(subject).to eq institution_code
                end
              end
            end
            context 'and there is not a sub library code' do
              it 'should not raise an error' do
                expect { subject }.not_to raise_error
              end
              it { should be_nil }
            end
          end
          context 'when there is an institution code' do
            let(:institution_code) { 'INST' }
            context 'and there is a sub library code' do
              context 'and it maps to an institution in the source config' do
                let(:sub_library_code) { 'BOBST' }
                it 'should get the institution from the sub library code' do
                  expect(subject).to eq 'NYU'
                end
              end
              context 'but it does not map to an institution in the source config' do
                let(:sub_library_code) { 'NOT_MAPPED' }
                it 'should get the institution from the sub library code' do
                  expect(subject).to eq institution_code
                end
              end
            end
            context 'and there is not a sub library code' do
              let(:sub_library_code) { nil }
              it { should eq institution_code }
            end
          end
        end
        describe '#library' do
          before { attributes[:library_code] = library_code }
          subject { nyu_aleph.library }
          context 'when initialized with a library code' do
            let(:library_code) { 'LIB' }
            context 'and there is not a sub library code' do
              let(:sub_library_code) { nil }
              context 'and the library code does not map to a library in the Primo config' do
                let(:library_code) { 'LIB' }
                it { should eq library_code }
              end
              context 'and library code does map to a library in the Primo config' do
                let(:library_code) { 'BFALE' }
                it { should eq 'NYU Bobst Fales' }
              end
            end
            context 'and there is a sub library code' do
              context 'and the sub library code has Aleph text defined' do
                let(:sub_library_code) { 'BFALE' }
                it { should eq 'NYU Bobst Special Collections' }
              end
              context 'and sub library code does not have Aleph text defined' do
                let(:sub_library_code) { 'SUBLIB' }
                it { should eq sub_library_code }
              end
            end
          end
          context 'when initialized without a library code' do
            let(:library_code) { nil }
            context 'and there is not a sub library code' do
              let(:sub_library_code) { nil }
              it 'should not raise an error' do
                expect { subject }.not_to raise_error
              end
              it { should be_nil }
            end
          end
        end
        describe '#collection' do
          before { attributes[:collection] = collection }
          subject { nyu_aleph.collection }
          context 'when initialized with a collection' do
            let(:collection) { 'collection' }
            context 'and there is not an ADM library code' do
              let(:adm_library_code) { nil }
              it { should eq collection }
            end
            context 'and there is an ADM library code' do
              let(:adm_library_code) { 'NYU50' }
              context 'but there is not a sub library code' do
                let(:sub_library_code) { nil }
                it { should eq collection }
              end
              context 'and there is sub library code' do
                let(:sub_library_code) { 'BOBST' }
                context 'but there is not a collection code' do
                  let(:collection_code) { nil }
                  it { should eq collection }
                end
                context 'and there is a collection code' do
                  context 'but it does not map to a collection in Aleph' do
                    let(:collection_code) { 'COLL' }
                    it { should eq collection }
                  end
                  context 'and it does map to a collection in Aleph' do
                    let(:collection_code) { 'MAIN' }
                    it { should_not eq collection }
                    it { should eq 'Main Collection' }
                  end
                end
              end
            end
          end
          context 'when initialized without a collection' do
            let(:collection) { nil }
            context 'and there is not an ADM library code' do
              let(:adm_library_code) { nil }
              it 'should not raise an error' do
                expect { subject }.not_to raise_error
              end
              it { should be_nil }
            end
          end
        end
        describe '#availability_status_code' do
          subject { nyu_aleph.availability_status_code }
          context 'when the circulation status is nil' do
            let(:circulation_status) { nil }
            context 'and availability_status_code is "available"' do
              let(:availability_status_code) { 'available' }
              it { should eq "available" }
            end
            context 'and availability_status_code is "check_holdings"' do
              let(:availability_status_code) { 'check_holdings' }
              it { should eq "check_holdings" }
            end
            context 'and availability_status_code is "unavailable"' do
              let(:availability_status_code) { 'unavailable' }
              it { should eq "unavailable" }
            end
          end
          context 'when the circulation status is "On Shelf"' do
            let(:circulation_status) { 'On Shelf' }
            it { should eq "available" }
          end
          context 'when the circulation status is "Available"' do
            let(:circulation_status) { 'Available' }
            it { should eq "available" }
          end
          context 'when the circulation status is "Offsite Available"' do
            let(:circulation_status) { 'Offsite Available' }
            it { should eq "offsite" }
          end
          context 'when the circulation status is "Requested"' do
            let(:circulation_status) { 'Requested' }
            it { should eq "requested" }
          end
          context 'when the circulation status is "Requested w/ some info"' do
            let(:circulation_status) { 'Requested w/ some info' }
            it { should eq "requested" }
          end
          context 'when the circulation status is "On Hold"' do
            let(:circulation_status) { 'On Hold' }
            it { should eq "requested" }
          end
          context 'when the circulation status is "Requested; On Hold"' do
            let(:circulation_status) { 'Requested; On Hold' }
            it { should eq "requested" }
          end
          context 'when the circulation status is "Reshelving"' do
            let(:circulation_status) { 'Reshelving' }
            it { should eq "reshelving" }
          end
          context 'when the circulation status is "Reshelving w/ some info"' do
            let(:circulation_status) { 'Reshelving w/ some info' }
            it { should eq "reshelving" }
          end
          context 'when the circulation status is "Recalled due date: 05/31/14"' do
            let(:circulation_status) { 'Recalled due date: 05/31/14' }
            it { should eq "recalled" }
          end
          context 'when the circulation status is "05/31/14"' do
            let(:circulation_status) { '05/31/14' }
            it { should eq "checked_out" }
          end
          context 'when the circulation status is "Billed as Lost"' do
            let(:circulation_status) { 'Billed as Lost' }
            it { should eq "billed_as_lost" }
          end
        end
        describe '#availability_status' do
          subject { nyu_aleph.availability_status }
          context 'when the circulation status is nil' do
            let(:circulation_status) { nil }
            context 'and there is no translated item status from the Aleph tables' do
              let(:item_status_code) { nil }
              let(:item_process_status_code) { nil }
              context 'and availability_status_code is "available"' do
                let(:availability_status_code) { 'available' }
                it { should eq "Available" }
              end
              context 'and availability_status_code is "check_holdings"' do
                let(:availability_status_code) { 'check_holdings' }
                it { should eq "Check Availability" }
              end
              context 'and availability_status_code is "unavailable"' do
                let(:availability_status_code) { 'unavailable' }
                it { should eq "Check Availability" }
              end
            end
            context 'and there is a translated item status from the Aleph tables' do
              let(:adm_library_code) { 'NYU50' }
              let(:sub_library_code) { 'BOBST' }
              let(:item_status_code) { '01' }
              let(:item_process_status_code) { 'DP' }
              it 'should be the translated item status' do
                expect(subject).to eq 'Offsite Available'
              end
            end
          end
          context 'when the circulation status is "On Shelf"' do
            let(:circulation_status) { 'On Shelf' }
            it { should eq "Available" }
          end
          context 'when the circulation status is "Available"' do
            let(:circulation_status) { 'Available' }
            it { should eq "Available" }
          end
          context 'when the circulation status is "Offsite Available"' do
            let(:circulation_status) { 'Offsite Available' }
            it { should eq "Offsite Available" }
          end
          context 'when the circulation status is "Requested"' do
            let(:circulation_status) { 'Requested' }
            it { should eq "Requested" }
          end
          context 'when the circulation status is "Requested w/ some info"' do
            let(:circulation_status) { 'Requested w/ some info' }
            it { should eq "Requested w/ some info" }
          end
          context 'when the circulation status is "On Hold"' do
            let(:circulation_status) { 'On Hold' }
            it { should eq "On Hold" }
          end
          context 'when the circulation status is "Requested; On Hold"' do
            let(:circulation_status) { 'Requested; On Hold' }
            it { should eq "Requested; On Hold" }
          end
          context 'when the circulation status is "Reshelving"' do
            let(:circulation_status) { 'Reshelving' }
            it { should eq "Reshelving" }
          end
          context 'when the circulation status is "Reshelving w/ some info"' do
            let(:circulation_status) { 'Reshelving w/ some info' }
            it { should eq "Reshelving" }
          end
          context 'when the circulation status is "Recalled due date: 05/31/14"' do
            let(:circulation_status) { 'Recalled due date: 05/31/14' }
            it { should eq "Due: 05/31/14" }
          end
          context 'when the circulation status is "05/31/14"' do
            let(:circulation_status) { '05/31/14' }
            it { should eq "Due: 05/31/14" }
          end
          context 'when the circulation status is "Billed as Lost"' do
            let(:circulation_status) { 'Billed as Lost' }
            it { should eq "Request ILL" }
          end
        end
        describe 'from_aleph?' do
          subject { nyu_aleph.from_aleph? }
          context 'when expanded from Aleph' do
            let(:from_aleph) { true }
            it { should be_true }
          end
          context 'when not expanded from Aleph' do
            let(:from_aleph) { false }
            it { should be_false }
          end
        end
        describe 'from_aleph' do
          subject { nyu_aleph.from_aleph }
          context 'when expanded from Aleph' do
            let(:from_aleph) { true }
            it { should be_true }
          end
          context 'when not expanded from Aleph' do
            let(:from_aleph) { false }
            it { should be_false }
          end
        end
        describe 'expanded?' do
          subject { nyu_aleph.expanded? }
          context 'when expanded from Aleph' do
            let(:from_aleph) { true }
            it { should be_true }
          end
          context 'when not expanded from Aleph' do
            let(:from_aleph) { false }
            it { should be_false }
          end
        end
        context 'when initialized with a Journal holding', vcr: { cassette_name: "vogue" } do
          let(:record_id) { "nyu_aleph002893728" }
          let(:search) { Exlibris::Primo::Search.new(record_id: record_id) }
          let(:records) { search.records }
          let(:holdings) { records.map{ |record| record.holdings }.flatten }
          subject(:vogue_nyu_aleph) { NyuAleph.new(holding: holding) }
          context 'and the holding has coverage statements in the bib MARC' do
            let(:holding) do
              holdings.find { |holding| holding.institution_code == "NYU" }
            end
            it { should be_an NyuAleph }
            describe '#coverage' do
              subject { vogue_nyu_aleph.coverage }
              it { should be_an Array }
              it { should_not be_empty }
              it 'should display the bib coverage statement' do
                expect(subject.size).to be 2
              end
            end
          end
          context 'and the holding has coverage statements in the holding MARC' do
            let(:holding) do
              holdings.find { |holding| holding.institution_code == "NS" }
            end
            it { should be_an NyuAleph }
            describe '#coverage' do
              subject { vogue_nyu_aleph.coverage }
              it { should be_an Array }
              it { should_not be_empty }
              it 'should display the holding coverage statement' do
                expect(subject.size).to be 2
              end
            end
          end
          context 'and the holding has coverage statements in both the bib and holding MARC' do
            let(:holding) do
              holdings.find { |holding| holding.institution_code == "NYHS" }
            end
            it { should be_an NyuAleph }
            describe '#coverage' do
              subject { vogue_nyu_aleph.coverage }
              it { should be_an Array }
              it { should_not be_empty }
              it 'should display the holding coverage statement' do
                expect(subject.size).to be 1
              end
            end
          end
        end
      end
    end
  end
end
