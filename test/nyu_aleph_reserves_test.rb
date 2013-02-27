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
      holdings.collect!{|holding| holding.to_source.expand}.flatten!
      bobst_holdings = holdings.find_all do |holding|
        holding.library.eql?("NYU Bobst Reserve Collection")
      end
      bobst_holdings.each do |bobst_holding|
        assert_equal("NYU30", bobst_holding.original_source_id)
        assert_equal("000193032", bobst_holding.source_record_id)
        assert_equal("000193032", bobst_holding.source_data[:source_record_id])
        assert_equal("NYU Bobst Reserve Collection", bobst_holding.library)
        assert_equal("", bobst_holding.collection)
        assert_equal("Available - Reserve 2 hour loan", bobst_holding.status)
        assert_equal("http://aleph.library.nyu.edu/F?func=item-global&doc_library=NYU30&local_base=PRIMOCOMMON&doc_number=000193032&sub_library=BRES", bobst_holding.url)
      end
    end
  end
end