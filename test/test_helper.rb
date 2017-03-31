require 'coveralls'
Coveralls.wear_merged!
require 'minitest/autorun'
require File.expand_path("../../lib/exlibris-nyu.rb",  __FILE__)
require 'pry'

# Use the included testmnt for testing.
Exlibris::Aleph.configure do |config|
  config.table_path = ENV["ALEPH_TABLE_PATH"] || "#{File.dirname(__FILE__)}/../test/mnt/aleph_tab"
end

# VCR is used to 'record' HTTP interactions with
# third party services used in tests, and play em
# back. Useful for efficiency, also useful for
# testing code against API's that not everyone
# has access to -- the responses can be cached
# and re-used.
require 'vcr'
require 'webmock'

@@aleph_rest_url = Exlibris::Aleph::Config.rest_url
@@aleph_url = Exlibris::Aleph::Config.base_url
@@primo_url = Exlibris::Primo::Config.base_url

VCR.configure do |c|
  c.cassette_library_dir = 'test/vcr_cassettes'
  # webmock needed for HTTPClient testing
  c.hook_into :webmock
  # c.debug_logger = $stderr
  c.filter_sensitive_data("http://aleph.library.edu") { Exlibris::Aleph::Config.base_url }
  c.filter_sensitive_data("http://primo.library.edu") { Exlibris::Primo::Config.base_url }
end

# Add Exlibris::Primo::Search to TestCase
# so we can search Primo.
class ActiveSupport::TestCase
  def exlibris_primo_search
    Exlibris::Primo::Search.new
  end
  protected :exlibris_primo_search
end
