require 'coveralls'
Coveralls.wear!
require 'test/unit'
require File.expand_path("../../lib/exlibris-nyu.rb",  __FILE__)

# Use the included testmnt for testing.
Exlibris::Aleph.configure do |config|
  config.tab_path = "#{File.dirname(__FILE__)}/../test/mnt/aleph_tab" if ENV['CI']
  config.yml_path = "#{File.dirname(__FILE__)}/../test/config/aleph" if ENV['CI']
end

# VCR is used to 'record' HTTP interactions with
# third party services used in tests, and play em
# back. Useful for efficiency, also useful for
# testing code against API's that not everyone
# has access to -- the responses can be cached
# and re-used.
require 'vcr'
require 'webmock'

@@aleph_url = "aleph.library.nyu.edu"
@@primo_url = "bobcat.library.nyu.edu"

VCR.configure do |c|
  c.cassette_library_dir = 'test/vcr_cassettes'
  # webmock needed for HTTPClient testing
  c.hook_into :webmock
  # c.debug_logger = $stderr
  c.filter_sensitive_data("aleph.library.edu") { @@aleph_url }
  c.filter_sensitive_data("primo.library.edu") { @@primo_url }
end

# Add Exlibris::Primo::Search to TestCase
# so we can search Primo.
class Test::Unit::TestCase
  def exlibris_primo_search
    Exlibris::Primo::Search.new
  end
  protected :exlibris_primo_search
end
