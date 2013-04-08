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
  s.add_dependency 'sufia'
  s.add_dependency 'morphine'
  s.add_dependency 'mini_magick'
  s.add_dependency 'simple_form'
  s.add_dependency 'active_attr'
  s.add_dependency 'bootstrap-datepicker-rails'
  s.add_dependency 'method_decorators'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency "mysql2"
  s.add_development_dependency "rspec"
end
