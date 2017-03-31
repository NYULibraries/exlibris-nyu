$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
require 'coveralls'
Coveralls.wear_merged!
require 'rspec'
require 'vcr'
require 'pry'
require 'exlibris-nyu'

# Use the included testmnt for testing.
Exlibris::Aleph.configure do |config|
  config.table_path = ENV["ALEPH_TABLE_PATH"] || "#{File.dirname(__FILE__)}/../test/mnt/aleph_tab"
end

def aleph_url
  @aleph_url ||= Exlibris::Aleph::Config.base_url
end

def primo_url
  @primo_url ||= Exlibris::Primo::Config.base_url
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.configure_rspec_metadata!
  c.hook_into :webmock
  c.filter_sensitive_data("http://aleph.library.edu") { aleph_url }
  c.filter_sensitive_data("http://primo.library.edu") { primo_url }
end

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Declare exclusion filters
  config.filter_run_excluding skip: true
end
