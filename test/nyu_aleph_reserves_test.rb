# encoding: utf-8
require 'test_helper'
class NyuAlephReservesTest < ActiveSupport::TestCase

  def setup
    @microeconomics_id = "COURSES000193032"
  end

  test "nyu_aleph_reserves book" do
    VCR.use_cassette('nyu_aleph reserves book') do
      holdings = 
        exlibris_primo_search.record_id!(@microeconomics_id).records.collect{|record| record.holdings}.flatten
      sources = []
      holdings.each do |holding|
        source = holding.to_source
        sources.concat(source.expand) unless sources.include? source
      end
      bobst_sources = sources.find_all do |source|
        source.library.eql?("NYU Bobst Reserve Collection")
      end
      bobst_sources.each do |bobst_source|
        assert_equal("NYU30", bobst_source.original_source_id)
        assert_equal("000193032", bobst_source.source_record_id)
        assert_equal("000193032", bobst_source.source_data[:source_record_id])
        assert_equal("NYU Bobst Reserve Collection", bobst_source.library)
        assert_equal("", bobst_source.collection)
        assert_equal("Available - Reserve 2 hour loan", bobst_source.status)
        assert_equal("http://#{@@aleph_url}/F?func=item-global&doc_library=NYU30&local_base=PRIMOCOMMON&doc_number=000193032&sub_library=BRES", bobst_source.url)
      end
    end
  end
end