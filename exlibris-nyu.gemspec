$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "exlibris/nyu/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "exlibris-nyu"
  s.version     = Exlibris::Nyu::VERSION
  s.authors     = ["Scot Dalton"]
  s.email       = ["scot.dalton@nyu.edu"]
  s.homepage    = "https://github.com/NYULibraries/exlibris-nyu"
  s.summary     = "NYU extensions to and configurations for the exlibris gems."
  s.description = "NYU extensions to and configurations for the exlibris gems. Does not require Rails."
  s.license     = 'MIT'

  s.files = Dir["{lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"] + Dir["spec/**/*"]

  s.add_dependency "require_all", "~> 1.3"
  s.add_dependency "exlibris-primo", "~> 1.1.6"
  # s.add_dependency "exlibris-aleph", "~> 2.0.0"

  s.add_development_dependency 'rake', '~> 10.3'
  s.add_development_dependency 'rspec', '~> 2.14'
  s.add_development_dependency 'activesupport', '~> 4.1.1'
  s.add_development_dependency 'vcr', '~> 2.9'
  s.add_development_dependency 'webmock', '~> 1.17'
  s.add_development_dependency 'pry', "~> 0.9.12"
end
