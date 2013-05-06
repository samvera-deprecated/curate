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
  s.add_dependency 'active-fedora', '~>5.6.2'
  s.add_dependency 'solrizer', '~>2'
  s.add_dependency 'hydra-head', '~>5.4.0'
  s.add_dependency 'morphine'
  s.add_dependency 'devise'
  s.add_dependency 'mini_magick'
  s.add_dependency 'simple_form'
  s.add_dependency 'active_attr'
  s.add_dependency 'bootstrap-datepicker-rails'
  s.add_dependency 'method_decorators'
  s.add_dependency 'devise'
  s.add_dependency "devise-guests", "~> 0.3"
  s.add_dependency 'roboto'
  s.add_dependency 'browser'
  s.add_dependency 'breadcrumbs_on_rails'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency "mysql2"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency 'rspec'
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "simplecov"
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'rspec-html-matchers'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'jettywrapper'
  s.add_development_dependency 'debugger'
end
