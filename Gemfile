source 'https://rubygems.org'

# This should be everything except :deploy; And by not_deploy, we mean any of
# the environments that are not used to execute the deploy scripts
group :not_deploy do
  gem 'rails', '3.2.11'
  gem 'mysql2'
  gem 'common_repository_model', git: 'git://github.com/ndlib/common_repository_model'
  gem 'sufia', git: 'git://github.com/ndlib/sufia.git', branch: 'sufia-for-curate-nd'
  gem 'solrizer'#, git: 'git://github.com/ndlib/solrizer.git'
  gem 'rsolr', git: 'git://github.com/jeremyf/rsolr.git', branch: 'adding-connection-information-to-error-handling'
  gem 'jettywrapper'
  gem 'jquery-rails'
  gem 'decent_exposure'
  gem 'devise_cas_authenticatable'
  gem 'rake'
  gem 'resque-pool'
  gem 'morphine'
  gem "unicode", :platforms => [:mri_18, :mri_19]
  gem "devise"
  gem "devise-guests", "~> 0.3"
  gem 'simple_form'
  gem 'roboto'
  # Need rubyracer to run integration tests.....really?!?
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platforms => :ruby
end

group :headless do
  gem 'clamav', require: false
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'bootstrap-sass', '~> 2.2.0'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'compass-rails'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'uglifier', '>= 1.0.3'
end

group :test, :development do
  gem 'factory_girl_rails'
  gem 'rspec-html-matchers'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'debugger'
  gem 'database_cleaner'
  gem 'sextant'
  gem 'capybara'
  gem 'simplecov'
  gem 'rails_best_practices'
end

group :deploy do
  gem 'capistrano'
end
