require 'exlibris-primo'
# Load Primo configuration
Exlibris::Primo.configure do |config|
  config.load_yaml File.expand_path("#{File.dirname(__FILE__)}/../config/primo.yml",  __FILE__)
end

require 'exlibris-aleph'
# Load Aleph configuration
Exlibris::Aleph.configure do |config|
  config.load_yaml File.expand_path("#{File.dirname(__FILE__)}/../config/aleph.yml",  __FILE__)
end

require "require_all"
require_all "#{File.dirname(__FILE__)}/exlibris/"

