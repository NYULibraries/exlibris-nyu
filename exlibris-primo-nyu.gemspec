$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "exlibris/primo/nyu/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "exlibris-primo-nyu"
  s.version     = Exlibris::Primo::Nyu::VERSION
  s.authors     = ["Scot Dalton"]
  s.email       = ["scot.dalton@nyu.edu"]
  s.homepage    = "https://github.com/NYULibraries/exlibris-primo-nyu"
  s.summary     = "NYU extensions to the exlibris-primo gem."
  s.description = "NYU extensions to the exlibris-primo gem. Does not require Rails."

  s.files = Dir["{lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rake", "~> 10.0.3"
  s.add_dependency "require_all", "~> 1.2.1"
  s.add_dependency "exlibris-primo", "~> 1.0.6"
  # s.add_dependency "exlibris-aleph", "~> 0.1.6"
  s.add_dependency "nokogiri", "~> 1.5.6"
  s.add_development_dependency "rdoc"
  s.add_development_dependency "vcr", "~> 2.4.0"
  s.add_development_dependency "webmock", "~> 1.9.3"
  s.add_development_dependency "simplecov", "~> 0.7.1"
  s.add_development_dependency "simplecov-rcov", "~> 0.2.3"
end
