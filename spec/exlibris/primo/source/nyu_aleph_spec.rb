require 'spec_helper'
# Vogue: nyu_aleph002893728
# Visionaire: nyu_aleph001951476
module Exlibris
  module Primo
    module Source
      describe NyuAleph, vcr: { cassette_name: 'virtual inequality', record: :new_episodes } do
        context 'when initialized with an Exlibris::Aleph::Item' do
          let(:source_record_id) {'000980206'}
          let(:record_id) { "NYU01#{source_record_id}" }
          let(:aleph_record) { Exlibris::Aleph::Record.new(record_id) }
          let(:aleph_item) { aleph_record.items.first }
          let(:nyu_aleph_item) { Exlibris::Nyu::Aleph::Item.new(aleph_item) }
          subject(:nyu_aleph) do
            NyuAleph.new(source_id: 'nyu_aleph', source_record_id: source_record_id, aleph_item: nyu_aleph_item)
          end
          it { should be_an NyuAleph }
          it { should be_an Aleph }
          it { should be_an Exlibris::Primo::Holding }
          describe '#==' do
            subject { nyu_aleph == other_object }
            context 'when the other object is an Exlibris::Primo::Holding' do
              let(:other_object) do
                Primo::Holding.new(source_id: other_source_id, source_record_id: other_source_record_id)
              end
              context 'and the source id is the same' do
                let(:other_source_id) { 'nyu_aleph' }
                context 'and the source record id is the same' do
                  let(:other_source_record_id) { '000980206' }
                  it { should be true }
                end
                context 'but the source record id is not the same' do
                  let(:other_source_record_id) { '000980207' }
                  it { should be false }
                end
              end
              context 'but the source id is not the same' do
                let(:other_source_id) { 'nyu_other' }
                context 'and the source record id is the same' do
                  let(:other_source_record_id) { '000980206' }
                  it { should be false }
                end
                context 'but the source record id is not the same' do
                  let(:other_source_record_id) { '000980207' }
                  it { should be false }
                end
              end
            end
            context 'when the other object is not an Exlibris::Primo::Holding' do
              let(:other_object) { "string" }
              it { should be false }
            end
          end
          describe '#eql?' do
            subject { nyu_aleph.eql?(other_object) }
            context 'when the other object is an Exlibris::Primo::Holding' do
              let(:other_object) do
                Primo::Holding.new(source_id: other_source_id, source_record_id: other_source_record_id)
              end
              context 'and the source id is the same' do
                let(:other_source_id) { 'nyu_aleph' }
                context 'and the source record id is the same' do
                  let(:other_source_record_id) { '000980206' }
                  it { should be true }
                end
                context 'but the source record id is not the same' do
                  let(:other_source_record_id) { '000980207' }
                  it { should be false }
                end
              end
              context 'but the source id is not the same' do
                let(:other_source_id) { 'nyu_other' }
                context 'and the source record id is the same' do
                  let(:other_source_record_id) { '000980206' }
                  it { should be false }
                end
                context 'but the source record id is not the same' do
                  let(:other_source_record_id) { '000980207' }
                  it { should be false }
                end
              end
            end
            context 'when the other object is not an Exlibris::Primo::Holding' do
              let(:other_object) { "string" }
              it { should be false }
            end
          end
          describe '#from_aleph?' do
            subject { nyu_aleph.from_aleph? }
            context 'when expanded from Aleph' do
              it { should be true }
            end
            context 'when not expanded from Aleph' do
              let(:nyu_aleph_item) { nil }
              it { should be false }
            end
          end
          describe '#expanded?' do
            subject { nyu_aleph.expanded? }
            context 'when expanded from Aleph' do
              it { should be true }
            end
            context 'when not expanded from Aleph' do
              let(:nyu_aleph_item) { nil }
              it { should be false }
            end
          end
          describe '#aleph_item' do
            subject { nyu_aleph.aleph_item }
            context 'when expanded from Aleph' do
              it { should be nyu_aleph_item }
            end
            context 'when not expanded from Aleph' do
              let(:nyu_aleph_item) { nil }
              it { should be_nil }
            end
          end
          describe '#institution_code' do
            subject { nyu_aleph.institution_code }
            it { should eq 'NYU' }
          end
          describe '#library' do
            subject { nyu_aleph.library }
            it { should be_an Exlibris::Aleph::SubLibrary }
            it 'should equal "NYU Bobst"' do
              expect("#{subject}").to eq 'NYU Bobst'
            end
          end
          describe '#sub_library' do
            subject { nyu_aleph.sub_library }
            it { should be_an Exlibris::Aleph::SubLibrary }
            it 'should equal "NYU Bobst"' do
              expect("#{subject}").to eq 'NYU Bobst'
            end
          end
          describe '#collection' do
            subject { nyu_aleph.collection }
            it { should be_an Exlibris::Aleph::Collection }
            it 'should equal "Main Collection"' do
              expect("#{subject}").to eq 'Main Collection'
            end
          end
          describe '#call_number' do
            subject { nyu_aleph.call_number }
            it { should be_an Exlibris::Nyu::Aleph::CallNumber }
            it 'should equal "(HN49.I56 M67 2003)"' do
              expect("#{subject}").to eq '(HN49.I56 M67 2003)'
            end
          end
          describe '#opac_note' do
            subject { nyu_aleph.opac_note }
            it { should be_an Exlibris::Aleph::Item::OpacNote }
            it 'should equal "OPAC Note"' do
              expect("#{subject}").to eq 'OPAC Note'
            end
          end
          describe '#number_of_requests' do
            subject { nyu_aleph.number_of_requests }
            it { should eq 1 }
          end
          describe '#status' do
            subject { nyu_aleph.status }
            context 'when expanded from Aleph' do
              it { should be_an Exlibris::Nyu::Aleph::Status }
              it 'should be "Due: 06/28/14"' do
                expect("#{subject}").to eq 'Due: 06/28/14'
              end
            end
            context 'when not expanded from Aleph' do
              let(:nyu_aleph_item) { nil }
              it { should be_nil }
            end
          end
          describe '#requestability' do
            subject { nyu_aleph.requestability }
            context 'when expanded from Aleph' do
              it { should eq 'deferred' }
            end
            context 'when not expanded from Aleph' do
              let(:nyu_aleph_item) { nil }
              it { should eq 'no' }
            end
          end
        end
        context 'when initialized with a holding' do
          let(:search) { Exlibris::Primo::Search.new(record_id: record_id) }
          let(:records) { search.records }
          let(:holdings) { records.map{ |record| record.holdings }.flatten }
          let(:holding) { holdings.first }
          subject(:nyu_aleph) { NyuAleph.new(holding: holding) }
          context 'and the holding is a book', vcr: { cassette_name: 'virtual inequality', record: :new_episodes } do
            let(:record_id) { 'nyu_aleph000980206' }
            describe '#==' do
              subject { nyu_aleph == other_object }
              context 'when the other object is an Exlibris::Primo::Holding' do
                let(:other_object) do
                  Primo::Holding.new(source_id: other_source_id, source_record_id: other_source_record_id)
                end
                context 'and the source id is the same' do
                  let(:other_source_id) { 'nyu_aleph' }
                  context 'and the source record id is the same' do
                    let(:other_source_record_id) { '000980206' }
                    it { should be true }
                  end
                  context 'but the source record id is not the same' do
                    let(:other_source_record_id) { '000980207' }
                    it { should be false }
                  end
                end
                context 'but the source id is not the same' do
                  let(:other_source_id) { 'nyu_other' }
                  context 'and the source record id is the same' do
                    let(:other_source_record_id) { '000980206' }
                    it { should be false }
                  end
                  context 'but the source record id is not the same' do
                    let(:other_source_record_id) { '000980207' }
                    it { should be false }
                  end
                end
              end
              context 'when the other object is not an Exlibris::Primo::Holding' do
                let(:other_object) { "string" }
                it { should be false }
              end
            end
            describe '#eql?' do
              subject { nyu_aleph.eql?(other_object) }
              context 'when the other object is an Exlibris::Primo::Holding' do
                let(:other_object) do
                  Primo::Holding.new(source_id: other_source_id, source_record_id: other_source_record_id)
                end
                context 'and the source id is the same' do
                  let(:other_source_id) { 'nyu_aleph' }
                  context 'and the source record id is the same' do
                    let(:other_source_record_id) { '000980206' }
                    it { should be true }
                  end
                  context 'but the source record id is not the same' do
                    let(:other_source_record_id) { '000980207' }
                    it { should be false }
                  end
                end
                context 'but the source id is not the same' do
                  let(:other_source_id) { 'nyu_other' }
                  context 'and the source record id is the same' do
                    let(:other_source_record_id) { '000980206' }
                    it { should be false }
                  end
                  context 'but the source record id is not the same' do
                    let(:other_source_record_id) { '000980207' }
                    it { should be false }
                  end
                end
              end
              context 'when the other object is not an Exlibris::Primo::Holding' do
                let(:other_object) { "string" }
                it { should be false }
              end
            end
            describe '#from_aleph?' do
              subject { nyu_aleph.from_aleph? }
              it { should be false }
            end
            describe '#expanded?' do
              subject { nyu_aleph.expanded? }
              it { should be false }
            end
            describe '#aleph_item' do
              subject { nyu_aleph.aleph_item }
              it { should be_nil }
            end
            describe '#institution_code' do
              subject { nyu_aleph.institution_code }
              it { should eq 'NYU' }
            end
            describe '#library' do
              subject { nyu_aleph.library }
              it { should be_an Exlibris::Aleph::SubLibrary }
              it 'should equal "NYU Bobst"'do
                expect("#{subject}").to eq 'NYU Bobst'
              end
            end
            describe '#sub_library' do
              subject { nyu_aleph.sub_library }
              it { should be_an Exlibris::Aleph::SubLibrary }
              it 'should equal "NYU Bobst"'do
                expect("#{subject}").to eq 'NYU Bobst'
              end
            end
            describe '#collection' do
              subject { nyu_aleph.collection }
              it { should be_an Exlibris::Aleph::Collection }
              it 'should equal "Main Collection"'do
                expect("#{subject}").to eq 'Main Collection'
              end
            end
            describe '#call_number' do
              subject { nyu_aleph.call_number }
              it { should_not be_an Exlibris::Nyu::Aleph::CallNumber }
              it { should eq '(HN49.I56 M67 2003 )' }
            end
            describe '#status' do
              subject { nyu_aleph.status }
              it { should_not be_an Exlibris::Nyu::Aleph::Status }
              it { should eq 'Check Availability' }
            end
            describe '#requestability' do
              subject { nyu_aleph.requestability }
              it { should_not be_nil }
              it { should eq 'no' }
            end
            describe '#opac_note' do
              subject { nyu_aleph.opac_note }
              it { should be_nil }
            end
            describe '#number_of_requests' do
              subject { nyu_aleph.number_of_requests }
              it { should eq 0 }
            end
            describe '#expand' do
              subject { nyu_aleph.expand }
              it 'should not raise an error' do
                expect { subject }.not_to raise_error
              end
              it { should be_an Array }
              it 'should have more than 1 element' do
                expect(subject.size).to be > 1
              end
              it 'should have 2 elements' do
                expect(subject.size).to be 2
              end
              it 'should not have the original holding as an element' do
                subject.each do |holding|
                  expect(holding).not_to be nyu_aleph
                end
              end
            end
            context 'and the holding is the result of an expansion' do
              subject(:expanded_nyu_aleph) { nyu_aleph.expand.first }
              it { should be_an NyuAleph }
              describe '#==' do
                subject { nyu_aleph == other_object }
                context 'when the other object is an Exlibris::Primo::Holding' do
                  let(:other_object) do
                    Primo::Holding.new(source_id: other_source_id, source_record_id: other_source_record_id)
                  end
                  context 'and the source id is the same' do
                    let(:other_source_id) { 'nyu_aleph' }
                    context 'and the source record id is the same' do
                      let(:other_source_record_id) { '000980206' }
                      it { should be true }
                    end
                    context 'but the source record id is not the same' do
                      let(:other_source_record_id) { '000980207' }
                      it { should be false }
                    end
                  end
                  context 'but the source id is not the same' do
                    let(:other_source_id) { 'nyu_other' }
                    context 'and the source record id is the same' do
                      let(:other_source_record_id) { '000980206' }
                      it { should be false }
                    end
                    context 'but the source record id is not the same' do
                      let(:other_source_record_id) { '000980207' }
                      it { should be false }
                    end
                  end
                end
                context 'when the other object is not an Exlibris::Primo::Holding' do
                  let(:other_object) { "string" }
                  it { should be false }
                end
              end
              describe '#eql?' do
                subject { nyu_aleph.eql?(other_object) }
                context 'when the other object is an Exlibris::Primo::Holding' do
                  let(:other_object) do
                    Primo::Holding.new(source_id: other_source_id, source_record_id: other_source_record_id)
                  end
                  context 'and the source id is the same' do
                    let(:other_source_id) { 'nyu_aleph' }
                    context 'and the source record id is the same' do
                      let(:other_source_record_id) { '000980206' }
                      it { should be true }
                    end
                    context 'but the source record id is not the same' do
                      let(:other_source_record_id) { '000980207' }
                      it { should be false }
                    end
                  end
                  context 'but the source id is not the same' do
                    let(:other_source_id) { 'nyu_other' }
                    context 'and the source record id is the same' do
                      let(:other_source_record_id) { '000980206' }
                      it { should be false }
                    end
                    context 'but the source record id is not the same' do
                      let(:other_source_record_id) { '000980207' }
                      it { should be false }
                    end
                  end
                end
                context 'when the other object is not an Exlibris::Primo::Holding' do
                  let(:other_object) { "string" }
                  it { should be false }
                end
              end
              describe '#from_aleph?' do
                subject { expanded_nyu_aleph.from_aleph? }
                it { should be true }
              end
              describe '#expanded?' do
                subject { expanded_nyu_aleph.expanded? }
                it { should be true }
              end
              describe '#aleph_item' do
                subject { expanded_nyu_aleph.aleph_item }
                it { should be_an Exlibris::Nyu::Aleph::Item }
              end
              describe '#institution_code' do
                subject { expanded_nyu_aleph.institution_code }
                it { should eq 'NYU' }
              end
              describe '#library' do
                subject { expanded_nyu_aleph.library }
                it { should be_an Exlibris::Aleph::SubLibrary }
                it 'should equal "NYU Bobst"' do
                  expect("#{subject}").to eq 'NYU Bobst'
                end
              end
              describe '#sub_library' do
                subject { expanded_nyu_aleph.sub_library }
                it { should be_an Exlibris::Aleph::SubLibrary }
                it 'should equal "NYU Bobst"' do
                  expect("#{subject}").to eq 'NYU Bobst'
                end
              end
              describe '#collection' do
                subject { expanded_nyu_aleph.collection }
                it { should be_an Exlibris::Aleph::Collection }
                it 'should equal "Main Collection"' do
                  expect("#{subject}").to eq 'Main Collection'
                end
              end
              describe '#call_number' do
                subject { expanded_nyu_aleph.call_number }
                it { should be_an Exlibris::Nyu::Aleph::CallNumber }
                it 'should equal "(HN49.I56 M67 2003)"' do
                  expect("#{subject}").to eq '(HN49.I56 M67 2003)'
                end
              end
              describe '#status' do
                subject { expanded_nyu_aleph.status }
                it { should be_an Exlibris::Nyu::Aleph::Status }
                it 'should equal "Due: 06/28/14' do
                  expect("#{subject}").to eq 'Due: 06/28/14'
                end
              end
              describe '#opac_note' do
                subject { expanded_nyu_aleph.opac_note }
                it { should be_an Exlibris::Aleph::Item::OpacNote }
                it 'should equal "OPAC Note' do
                  expect("#{subject}").to eq 'OPAC Note'
                end
              end
              describe '#number_of_requests' do
                subject { expanded_nyu_aleph.number_of_requests }
                it { should eq 1 }
              end
              describe '#requestability' do
                subject { expanded_nyu_aleph.requestability }
                it { should eq 'deferred' }
              end
            end
          end
          context 'and the holding journal' do
            context 'and the journal is "Visionaire"', vcr: { cassette_name: 'visionaire', record: :new_episodes } do
              let(:record_id) { 'nyu_aleph001951476' }
              describe '#==' do
                subject { nyu_aleph == other_object }
                context 'when the other object is an Exlibris::Primo::Holding' do
                  let(:other_object) do
                    Primo::Holding.new(source_id: other_source_id, source_record_id: other_source_record_id)
                  end
                  context 'and the source id is the same' do
                    let(:other_source_id) { 'nyu_aleph' }
                    context 'and the source record id is the same' do
                      let(:other_source_record_id) { '001951476' }
                      it { should be false }
                    end
                    context 'but the source record id is not the same' do
                      let(:other_source_record_id) { '001951477' }
                      it { should be false }
                    end
                  end
                  context 'but the source id is not the same' do
                    let(:other_source_id) { 'nyu_other' }
                    context 'and the source record id is the same' do
                      let(:other_source_record_id) { '001951476' }
                      it { should be false }
                    end
                    context 'but the source record id is not the same' do
                      let(:other_source_record_id) { '001951477' }
                      it { should be false }
                    end
                  end
                end
                context 'when the other object is not an Exlibris::Primo::Holding' do
                  let(:other_object) { "string" }
                  it { should be false }
                end
              end
              describe '#eql?' do
                subject { nyu_aleph.eql?(other_object) }
                context 'when the other object is an Exlibris::Primo::Holding' do
                  let(:other_object) do
                    Primo::Holding.new(source_id: other_source_id, source_record_id: other_source_record_id)
                  end
                  context 'and the source id is the same' do
                    let(:other_source_id) { 'nyu_aleph' }
                    context 'and the source record id is the same' do
                      let(:other_source_record_id) { '001951476' }
                      it { should be false }
                    end
                    context 'but the source record id is not the same' do
                      let(:other_source_record_id) { '001951477' }
                      it { should be false }
                    end
                  end
                  context 'but the source id is not the same' do
                    let(:other_source_id) { 'nyu_other' }
                    context 'and the source record id is the same' do
                      let(:other_source_record_id) { '001951476' }
                      it { should be false }
                    end
                    context 'but the source record id is not the same' do
                      let(:other_source_record_id) { '001951477' }
                      it { should be false }
                    end
                  end
                end
                context 'when the other object is not an Exlibris::Primo::Holding' do
                  let(:other_object) { "string" }
                  it { should be false }
                end
              end
              describe '#from_aleph?' do
                subject { nyu_aleph.from_aleph? }
                it { should be false }
              end
              describe '#expanded?' do
                subject { nyu_aleph.expanded? }
                it { should be false }
              end
              describe '#aleph_item' do
                subject { nyu_aleph.aleph_item }
                it { should be_nil }
              end
              describe '#institution_code' do
                subject { nyu_aleph.institution_code }
                it { should eq 'NS' }
              end
              describe '#library' do
                subject { nyu_aleph.library }
                it { should be_an Exlibris::Aleph::SubLibrary }
                it 'should equal "New School Gimbel Library"'do
                  expect("#{subject}").to eq 'New School Gimbel Library'
                end
              end
              describe '#sub_library' do
                subject { nyu_aleph.sub_library }
                it { should be_an Exlibris::Aleph::SubLibrary }
                it 'should equal "New School Gimbel Library"'do
                  expect("#{subject}").to eq 'New School Gimbel Library'
                end
              end
              describe '#collection' do
                subject { nyu_aleph.collection }
                it { should be_an Exlibris::Aleph::Collection }
                it 'should equal "SpecCol Periodicals"'do
                  expect("#{subject}").to eq 'SpecCol Periodicals'
                end
              end
              describe '#expand' do
                subject { nyu_aleph.expand }
                it 'should not raise an error' do
                  expect { subject }.not_to raise_error
                end
                it { should be_an Array }
                it 'should have 1 element' do
                  expect(subject.size).to be 1
                end
                it 'should have the original holding as the element' do
                  expect(subject.first).to be nyu_aleph
                end
              end
              describe '#coverage' do
                subject { nyu_aleph.coverage }
                it { should be_an Array }
                it { should_not be_empty }
                it 'should display the notes' do
                  expect(subject.size).to be 1
                  expect(subject.first).to eql 'Note: Some volumes held OffSite -- consult detailed holdings for location.'
                end
              end
            end
            context 'and the journal is "Vogue"', vcr: { cassette_name: 'vogue', record: :new_episodes } do
              let(:record_id) { "nyu_aleph002893728" }
              context 'and the holding has coverage statements in the bib MARC' do
                let(:holding) do
                  holdings.find do |holding|
                    holding.institution_code == "NYU" && holding.collection == "Microform"
                  end
                end
                it { should be_an NyuAleph }
                describe '#coverage' do
                  subject { nyu_aleph.coverage }
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
                  subject { nyu_aleph.coverage }
                  it { should be_an Array }
                  it { should_not be_empty }
                  it 'should display the holding coverage statement' do
                    expect(subject.size).to be 1
                  end
                end
              end
              context 'and the holding has coverage statements in both the bib and holding MARC' do
                let(:holding) do
                  holdings.find { |holding| holding.institution_code == "NYHS" }
                end
                it { should be_an NyuAleph }
                describe '#coverage' do
                  subject { nyu_aleph.coverage }
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
  end
end