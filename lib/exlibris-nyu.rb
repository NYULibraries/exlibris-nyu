require 'exlibris-primo'
# Load Primo configuration
primo_configuration_file =
  File.expand_path("#{File.dirname(__FILE__)}/../config/primo.yml",  __FILE__)
primo_configuration = YAML.load_file(primo_configuration_file)
primo_configuration.merge!(primo_configuration[ENV['RAILS_ENV']]) unless primo_configuration[ENV['RAILS_ENV']].nil?
Exlibris::Primo.configure do |config|
  config.load_hash primo_configuration
end

require 'exlibris-aleph'
aleph_configuration_file =
  File.expand_path("#{File.dirname(__FILE__)}/../config/aleph.yml",  __FILE__)
aleph_configuration = YAML.load_file(aleph_configuration_file)
aleph_configuration.merge!(YAML.load_file(aleph_configuration_file)[ENV['RAILS_ENV']]) unless YAML.load_file(aleph_configuration_file)[ENV['RAILS_ENV']].nil?
# Load Aleph configuration
Exlibris::Aleph.configure do |config|
  config.adms = aleph_configuration['adms']
  config.base_url = aleph_configuration['base_url']
  config.rest_url = aleph_configuration['rest_url']
  config.table_path = aleph_configuration['table_path']
end

require "require_all"
require_all "#{File.dirname(__FILE__)}/exlibris/"
