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

  s.files = Dir["{app,config,db,lib,vendor}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]
  s.required_ruby_version     = '>= 1.9.3'
  s.require_paths = ["lib"]
  s.licenses = ['APACHE2']

  s.add_dependency "rails", "~>4.0.2"
  s.add_dependency "breach-mitigation-rails"
  s.add_dependency 'sufia-models', '~>3.4.0'
#  s.add_dependency 'hydra', '6.1.0.rc8'
  s.add_dependency 'hydra-file_characterization', ">= 0.2.3"
  s.add_dependency 'hydra-batch-edit', '~> 1.1.1'
  s.add_dependency 'hydra-collections', '~> 1.3.0'
  s.add_dependency 'morphine'
  s.add_dependency 'mini_magick'
  s.add_dependency 'simple_form', '~> 3.0.1'
  s.add_dependency 'active_attr'
  s.add_dependency 'bootstrap-datepicker-rails'
  s.add_dependency 'devise'
  s.add_dependency "devise-guests", "~> 0.3"
  s.add_dependency 'browser'
  s.add_dependency 'breadcrumbs_on_rails'
  s.add_dependency 'active_fedora-registered_attributes', '~> 0.2.0'
  s.add_dependency 'hydra-remote_identifier', '~> 0.6', '>= 0.6.7'
  s.add_dependency 'hydra-derivatives', '~> 0.0.7'
  s.add_dependency 'chronic', '>= 0.10.2'
  s.add_dependency 'virtus'
  s.add_dependency 'rails_autolink'
  s.add_dependency 'rubydora', '~> 1.7.4'
  s.add_dependency 'browse-everything'
  s.add_dependency 'httparty'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency "rspec-rails", '~> 3.0'
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency 'rspec-html-matchers', '~> 0.6'
  s.add_development_dependency 'rspec-its', '~> 1.0.1'
  s.add_development_dependency 'rspec-activemodel-mocks', '~> 1.0.1'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'timecop'
  s.add_development_dependency 'jettywrapper'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'database_cleaner', '< 1.1.0'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'test_after_commit'
end
