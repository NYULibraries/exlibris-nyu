# encoding: utf-8
require 'test_helper'
class NyuAlephTest < ActiveSupport::TestCase

  setup do
    @frankenstein_isbn = "9780393964585"
    @the_new_yorker_issn = "0028-792X"
    @temple_of_deir_el_bahari_id = "nyu_aleph002626473"
    @chemistry_the_molecular_nature_of_matter_and_change_id = "nyu_aleph003079903"
    @naked_statistics_id = "nyu_aleph003710159"
    @flatbreads_and_flavors_id = "nyu_aleph002365745"
  end

  test "nyu_aleph new book" do
    holding = Exlibris::Primo::Holding.new()
    assert_not_nil(holding)
    holding = Exlibris::Primo::Holding.new({
      :display_type => "book",
      :library_code => "BREF",
      :title => "Digital divide : civic engagement, information poverty, and the Internet worldwide",
      :record_id => "nyu_aleph000655588",
      :source_id => "nyu_aleph",
      :original_source_id => "NYU01",
      :source_record_id => "000655588"})
    assert_not_nil(holding)
    assert_equal("nyu_aleph000655588", holding.record_id)
    assert_nil(holding.call_number)
    assert_nil(holding.status_code)
    assert_nil(holding.status)
    assert((not holding.respond_to?(:adm_library_code)))
    assert((not holding.respond_to?(:sub_library_code)))
    assert((not holding.respond_to?(:sub_library)))
    assert((not holding.respond_to?(:collection_code)))
    assert_nil(holding.collection)
    assert((not holding.respond_to?(:item_status_code)))
    assert((not holding.respond_to?(:item_process_status_code)))
    assert((not holding.respond_to?(:circulation_status)))
    assert_equal("BREF", holding.library_code)
    assert_equal("NYU Bobst Reference", holding.library)
    assert(holding.coverage.empty?)
    VCR.use_cassette('nyu_aleph new book') do
      nyu_aleph = holding.to_source.expand.first
      assert_equal("(HN49.I56 N67 2001)", nyu_aleph.call_number)
      assert_equal("available", nyu_aleph.status_code)
      assert_equal("Available", nyu_aleph.status)
      assert_equal("NYU50", nyu_aleph.adm_library_code)
      assert_equal("BOBST", nyu_aleph.sub_library_code)
      assert_equal("NYU", nyu_aleph.institution_code)
      assert_equal("NYU Bobst", nyu_aleph.sub_library)
      assert_equal("MAIN", nyu_aleph.collection_code)
      assert_equal("Main Collection", nyu_aleph.collection)
      assert_equal("01", nyu_aleph.item_status_code)
      assert_nil(nyu_aleph.item_process_status_code)
      assert_equal("BREF", nyu_aleph.library_code)
      assert_equal("NYU Bobst", nyu_aleph.library)
      assert(nyu_aleph.coverage.empty?)
    end
  end

  test "nyu_aleph new journal" do
    holding = Exlibris::Primo::Holding.new()
    assert_not_nil(holding)
    holding = Exlibris::Primo::Holding.new({
      :display_type => "journal",
      :title => "New Yorker (New York, N.Y. : 1925)",
      :institution_code => "NYU",
      :library_code => "BOBST",
      :record_id => "nyu_aleph002904404",
      :source_id => "nyu_aleph",
      :original_source_id => "NYU01",
      :source_record_id => "002904404"})
    assert_not_nil(holding)
    assert_equal("nyu_aleph002904404", holding.record_id)
    assert_nil(holding.call_number)
    assert_nil(holding.status_code)
    assert_nil(holding.status)
    assert((not holding.respond_to?(:adm_library_code)))
    assert((not holding.respond_to?(:sub_library_code)))
    assert((not holding.respond_to?(:sub_library)))
    assert((not holding.respond_to?(:collection_code)))
    assert_nil(holding.collection)
    assert((not holding.respond_to?(:item_status_code)))
    assert((not holding.respond_to?(:item_process_status_code)))
    assert((not holding.respond_to?(:circulation_status)))
    assert_equal("BOBST", holding.library_code)
    assert_equal("NYU", holding.institution_code)
    assert_equal("NYU Bobst", holding.library)
    assert(holding.coverage.empty?)
    VCR.use_cassette('nyu_aleph new journal') do
      nyu_aleph = holding.to_source.expand.first
      assert_nil(nyu_aleph.call_number)
      assert_nil(nyu_aleph.status_code)
      assert_nil(nyu_aleph.status)
      assert_nil(nyu_aleph.adm_library_code)
      assert_nil(nyu_aleph.sub_library_code)
      assert_nil(nyu_aleph.sub_library)
      assert_nil(nyu_aleph.collection_code)
      assert_nil(nyu_aleph.collection)
      assert_nil(nyu_aleph.item_status_code)
      assert_nil(nyu_aleph.item_process_status_code)
      assert_equal("BOBST", nyu_aleph.library_code)
      assert_equal("NYU", holding.institution_code)
      assert_equal("NYU Bobst", nyu_aleph.library)
      assert((not nyu_aleph.coverage.empty?), "Journal coverage is empty")
      assert_equal(1, nyu_aleph.coverage.size)
    end
  end

  test "nyu_aleph expand book" do
    holding = Exlibris::Primo::Holding.new({
      :display_type => "book",
      :title => "Digital divide : civic engagement, information poverty, and the Internet worldwide",
      :record_id => "nyu_aleph000655588",
      :source_id => "nyu_aleph",
      :original_source_id => "NYU01",
      :source_record_id => "000655588"})
    assert_not_nil(holding)
    assert_equal("nyu_aleph000655588", holding.record_id)
    assert_nil(holding.call_number)
    other_holding = Exlibris::Primo::Holding.new({
      :source_id => "nyu_aleph",
      :source_record_id => "000655588"})
    VCR.use_cassette('nyu_aleph expand book') do
      nyu_alephs = holding.to_source.expand
      assert((not nyu_alephs.empty?))
      assert_equal(2, nyu_alephs.size)
      assert(nyu_alephs.first == other_holding)
      assert(nyu_alephs.include? other_holding)
    end
  end

  test "nyu_aleph equality" do
    VCR.use_cassette('nyu_aleph equality') do
      holding = Exlibris::Primo::Holding.new({
        :display_type => "book",
        :title => "Digital divide : civic engagement, information poverty, and the Internet worldwide",
        :record_id => "nyu_aleph000655588",
        :source_id => "nyu_aleph",
        :original_source_id => "NYU01",
        :source_record_id => "000655588"})
      other_holding = Exlibris::Primo::Holding.new({
        :source_id => "nyu_aleph",
        :source_record_id => "000655588"})
      assert((not holding.eql?(other_holding)))
      assert holding.to_source.eql?(other_holding)
    end
  end

  test "nyu_aleph checked out book" do
    holding = Exlibris::Primo::Holding.new({
      :display_type => "book",
      :title => "Peanuts gallery : for piano and orchestra",
      :record_id => "nyu_aleph001244378",
      :source_id => "nyu_aleph",
      :original_source_id => "NYU01",
      :source_record_id => "001244378"})
      VCR.use_cassette('nyu_aleph checked out book') do
        nyu_aleph = holding.to_source.expand.first
        assert_equal("checked_out", nyu_aleph.status_code)
        assert_equal("Due: 06/04/13", nyu_aleph.status)
      end
  end

  test "nyu_aleph expand journal" do
    holding = Exlibris::Primo::Holding.new({
      :display_type => "journal",
      :title => "New Yorker (New York, N.Y. : 1925)",
      :record_id => "nyu_aleph002904404",
      :source_id => "nyu_aleph",
      :original_source_id => "NYU01",
      :source_record_id => "002904404"})
    assert_not_nil(holding)
    assert_equal("nyu_aleph002904404", holding.record_id)
    assert_nil(holding.call_number)
    VCR.use_cassette('nyu_aleph expand journal') do
      nyu_alephs = holding.to_source.expand
      assert((not nyu_alephs.empty?))
      assert_equal(1, nyu_alephs.size)
    end
  end

  test "nyu_aleph primo book source" do
    VCR.use_cassette('nyu_aleph primo book source') do
      holdings =
        exlibris_primo_search.isbn_is(@frankenstein_isbn).records.collect{|record| record.holdings}.flatten
      assert_equal(3, holdings.size, "Holdings size mismatch")
      sources = []
      holdings.each do |holding|
        source = holding.to_source
        sources.concat(source.expand) unless sources.include? source
      end
      assert_equal(6, sources.size)
      sources.each { |source| assert source.expanded?, "Not expanded" }
    end
  end

  test "nyu_aleph primo journal source" do
    VCR.use_cassette('nyu_aleph primo journal source') do
      holdings =
        exlibris_primo_search.isbn_is(@the_new_yorker_issn).records.collect{|record| record.holdings}.flatten
      assert_equal(6, holdings.size, "Holdings size mismatch")
      sources = []
      holdings.each do |holding|
        source = holding.to_source
        # This is a journal, so we shouldn't be expanding.
        assert((not source.send(:expanding?)), "Expanding journal")
        sources.concat(source.expand) unless sources.include? source
      end
      assert_equal(6, sources.size)
    end
  end

  test "nyu_aleph expanded collections" do
    VCR.use_cassette('nyu_aleph expanded collections') do
      holdings =
        exlibris_primo_search.record_id!(@temple_of_deir_el_bahari_id).records.collect{|record| record.holdings}.flatten
      assert_equal(5, holdings.size, "Holdings size mismatch")
      sources = []
      holdings.each do |holding|
        source = holding.to_source
        sources.concat(source.expand) unless sources.include? source
      end
      assert_equal(24, sources.size)
      cu_main_collection_sources = sources.find_all do |source|
        (source.library.eql?("Cooper Union Library") and
          source.collection.eql?("Main Collection"))
      end
      cu_main_collection_sources.each do |source|
        assert(source.expanded?, "Not expanded")
        assert(source.from_aleph, "The holding should be from Aleph")
        assert_equal("CU", source.institution)
      end
      assert_equal(2, cu_main_collection_sources.length)
    end
  end

  test "nyu_aleph requestability" do
    VCR.use_cassette('nyu_aleph requestability') do
      holdings =
        exlibris_primo_search.isbn_is(@frankenstein_isbn).records.collect{|record| record.holdings}.flatten
      sources = []
      holdings.each do |holding|
        source = holding.to_source
        sources.concat(source.expand) unless sources.include? source
      end
      assert_equal(6, sources.size)
      sources.each do |source|
        assert source.expanded?, "Not expanded?"
        assert_equal("deferred", source.requestability)
      end
    end
  end

  test "nyu_aleph mismatched more info urls" do
    VCR.use_cassette('nyu_aleph mismatched more info urls') do
      holdings =
        exlibris_primo_search.record_id!(@chemistry_the_molecular_nature_of_matter_and_change_id).records.collect{|record| record.holdings}.flatten
      sources = []
      holdings.each do |holding|
        source = holding.to_source
        sources.concat(source.expand) unless sources.include? source
      end
      bobst_sources = sources.find_all do |source|
        source.library.eql?("NYU Bobst")
      end
      bobst_sources.each do |bobst_source|
        assert(bobst_source.expanded?, "Not expanded")
        assert(bobst_source.from_aleph, "The holding should be from Aleph")
        assert_equal("NYU01", bobst_source.original_source_id)
        assert_equal("003079903", bobst_source.source_record_id)
        assert_equal("003079903", bobst_source.source_data[:source_record_id])
        assert_equal("#{@@aleph_url}/F?func=item-global&doc_library=NYU01&local_base=PRIMOCOMMON&doc_number=003079903&sub_library=BOBST", bobst_source.url)
      end
    end
  end

  test "nyu_aleph on hold requested" do
    VCR.use_cassette('nyu_aleph on hold requested') do
      holdings =
        exlibris_primo_search.record_id!(@naked_statistics_id).records.collect{|record| record.holdings}.flatten
      sources = []
      holdings.each do |holding|
        source = holding.to_source
        sources.concat(source.expand) unless sources.include? source
      end
      bobst_sources = sources.find_all do |source|
        source.library.eql?("NYU Bobst")
      end
      bobst_sources.each do |bobst_source|
        assert(bobst_source.expanded?, "Not expanded")
        assert(bobst_source.from_aleph, "The holding should be from Aleph")
        assert_equal("4 request(s) of 1 items.", bobst_source.queue)
        assert_equal("requested", bobst_source.status_code)
        assert_equal("On Hold; Requested", bobst_source.status)
        assert_equal("NYU01", bobst_source.original_source_id)
        assert_equal("003710159", bobst_source.source_record_id)
        assert_equal("003710159", bobst_source.source_data[:source_record_id])
        assert_equal("#{@@aleph_url}/F?func=item-global&doc_library=NYU01&local_base=PRIMOCOMMON&doc_number=003710159&sub_library=BOBST", bobst_source.url)
      end
    end
  end

  test "nyu_aleph reshelving" do
    VCR.use_cassette('nyu_aleph reshelving') do
      holdings =
        exlibris_primo_search.record_id!(@flatbreads_and_flavors_id).records.collect{|record| record.holdings}.flatten
      sources = []
      holdings.each do |holding|
        source = holding.to_source
        sources.concat(source.expand) unless sources.include? source
      end
      bobst_sources = sources.find_all do |source|
        source.library.eql?("NYU Bobst")
      end
      bobst_sources.each do |bobst_source|
        assert(bobst_source.expanded?, "Not expanded")
        assert(bobst_source.from_aleph, "The holding should be from Aleph")
        assert_equal("reshelving", bobst_source.status_code)
        assert_equal("Reshelving", bobst_source.status)
        assert_equal("NYU01", bobst_source.original_source_id)
        assert_equal("002365745", bobst_source.source_record_id)
        assert_equal("002365745", bobst_source.source_data[:source_record_id])
        assert_equal("#{@@aleph_url}/F?func=item-global&doc_library=NYU01&local_base=PRIMOCOMMON&doc_number=002365745&sub_library=BOBST", bobst_source.url)
      end
    end
  end

  test "nyu_aleph recalled" do
    VCR.use_cassette('nyu_aleph recalled') do
      holdings =
        exlibris_primo_search.record_id!(@flatbreads_and_flavors_id).records.collect{|record| record.holdings}.flatten
      sources = []
      holdings.each do |holding|
        source = holding.to_source
        sources.concat(source.expand) unless sources.include? source
      end
      bobst_sources = sources.find_all do |source|
        source.library.eql?("NYU Bobst")
      end
      bobst_sources.each do |bobst_source|
        assert(bobst_source.expanded?, "Not expanded")
        assert(bobst_source.from_aleph, "The holding should be from Aleph")
        assert_equal("recalled", bobst_source.status_code)
        assert_equal("Due: 03/10/13", bobst_source.status)
        assert_equal("NYU01", bobst_source.original_source_id)
        assert_equal("003710159", bobst_source.source_record_id)
        assert_equal("003710159", bobst_source.source_data[:source_record_id])
        assert_equal("#{@@aleph_url}/F?func=item-global&doc_library=NYU01&local_base=PRIMOCOMMON&doc_number=003710159&sub_library=BOBST", bobst_source.url)
      end
    end
  end

  test "nyu_aleph down" do
    VCR.use_cassette('nyu_aleph down', record: :new_episodes) do
      begin
        # Switch to a non-responsive URL (connection refused)
        Exlibris::Aleph::Config.rest_url = "http://library.nyu.edu:1891/rest-dlf"
        holdings =
          exlibris_primo_search.isbn_is(@frankenstein_isbn).records.collect{|record| record.holdings}.flatten
        assert_equal(3, holdings.size, "Holdings size mismatch")
        holdings.each do |holding|
          nyu_aleph = holding.to_source
          # Aleph is a down, so we shouldn't be expanding.
          assert((not nyu_aleph.send(:expanding?)),
            "Aleph is down, so we shouldn't be expanding the book")
        end
        sources = []
        holdings.each do |holding|
          source = holding.to_source
          sources.concat(source.expand) unless sources.include? source
        end
        assert_equal(3, sources.size)
      ensure
        # Ensure we reset the Aleph configuration
        Exlibris::Aleph::Config.rest_url = @@aleph_rest_url
      end
    end
  end

  test "nyu_aleph missing request permissions" do
    VCR.use_cassette('nyu_aleph missing request permissions') do
      holdings =
        exlibris_primo_search.record_id!("nyu_aleph003921627").records.collect{|record| record.holdings}.flatten
      sources = []
      holdings.each do |holding|
        source = holding.to_source
        sources.concat(source.expand) unless sources.include? source
      end
      abu_dhabi_sources = sources.find_all do |source|
        source.library.starts_with?("NYU Abu Dhabi")
      end
      assert(abu_dhabi_sources.size > 0, "Don't have any sources")
      abu_dhabi_sources.each do |abu_dhabi_source|
        assert(abu_dhabi_source.expanded?, "Not expanded")
        assert(abu_dhabi_source.from_aleph, "The holding should be from Aleph")
        assert_nothing_raised { abu_dhabi_source.requestability }
          assert_equal(Exlibris::Nyu::Holding::Requestability::NO, abu_dhabi_source.requestability)
      end
    end
  end
end