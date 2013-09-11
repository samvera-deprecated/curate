# Given that curate provides custom matchers, factories, etc.
# When someone makes use of curate in their Rails application
# Then we should expose those spec support files to that applications
spec_directory = File.expand_path('../../../spec', __FILE__)
require "rails/test_help"
require 'rspec/rails'
require 'rspec-html-matchers'
require 'rspec/autorun'
require 'factory_girl'
require 'factory_girl/strategy/reuse'
Dir["#{spec_directory}/factories/**/*.rb"].each { |f| require f }
Dir["#{spec_directory}/support/**/*.rb"].each { |f| require f }