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

# Load Rails specific configuration if we're in a Rails environment
if defined?(::Rails) && ::Rails.version >= '3.1.0'
  ActiveSupport.on_load(:after_initialize) do
    Exlibris::Aleph.configure do |config|
      config.logger = Rails.logger
      config.yml_path = "#{Rails.root}/config/aleph"
    end
  end
end

require "require_all"
require_all "#{File.dirname(__FILE__)}/exlibris/"

