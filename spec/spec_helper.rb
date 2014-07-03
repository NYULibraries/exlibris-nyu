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
  config.table_path = "#{File.dirname(__FILE__)}/../test/mnt/aleph_tab" if ENV['CI']
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
  # so we can use :vcr rather than :vcr => true;
  # in RSpec 3 this will no longer be necessary.
  config.treat_symbols_as_metadata_keys_with_true_values = true

  # Declare exclusion filters
  config.filter_run_excluding skip: true
end
