$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "curate/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "curate"
  s.version     = Curate::VERSION
  s.authors     = [
    "Jeremy Friesen",
  ]
  s.email       = [
    "jeremy.n.friesen@gmail.com"
  ]
  s.homepage    = "https://github.com/ndlib/curate"
  s.summary     = "A data curation Ruby on Rails engine built on Hydra and Sufia"
  s.description = "A data curation Ruby on Rails engine built on Hydra and Sufia"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "3.2.11"

  s.add_development_dependency "mysql2"
end
