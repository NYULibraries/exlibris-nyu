require 'exlibris-primo'
# Load Primo configuration
primo_configuration_file =
  File.expand_path("#{File.dirname(__FILE__)}/../config/primo.yml",  __FILE__)
Exlibris::Primo.configure do |config|
  config.load_yaml primo_configuration_file
end

require 'exlibris-aleph'
aleph_configuration_file =
  File.expand_path("#{File.dirname(__FILE__)}/../config/aleph.yml",  __FILE__)
aleph_configuration = YAML.load(ERB.new(File.read(aleph_configuration_file)).result)
# Load Aleph configuration
Exlibris::Aleph.configure do |config|
  config.adms = aleph_configuration['adms']
  config.base_url = aleph_configuration['base_url']
  config.rest_url = aleph_configuration['rest_url']
  config.table_path = aleph_configuration['table_path']
end

require "require_all"
require_all "#{File.dirname(__FILE__)}/exlibris/"
