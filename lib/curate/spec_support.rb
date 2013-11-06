# Given that curate provides custom matchers, factories, etc.
# When someone makes use of curate in their Rails application
# Then we should expose those spec support files to that applications
spec_directory = File.expand_path('../../../spec', __FILE__)
require "rails/test_help"
require 'rspec/rails'
require 'rspec-html-matchers'
require 'factory_girl'
require 'capybara/poltergeist'
Dir["#{spec_directory}/factories/**/*.rb"].each { |f| require f }
Dir["#{spec_directory}/support/**/*.rb"].each { |f| require f }

Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, :inspector => true)
end

require 'vcr'

def VCR::SpecSupport(options={})
  {vcr: {record: :new_episodes}.merge(options)}
end


# Because Fedora sends the username and password inline
FEDORA_OR_SOLR_HTTP_HOST = Regexp.compile("#{ActiveFedora.solr_config[:url].sub(/^https?:\/\//,'')}|#{ActiveFedora.fedora_config.credentials[:url].sub(/^https?:\/\//, '')}")

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.ignore_request do |request|
    request.uri =~ FEDORA_OR_SOLR_HTTP_HOST
  end
end

module FeatureSupport
  module_function
  def options(default = {type: :feature})
    if ENV['JS']
      Capybara.javascript_driver = default.fetch(:javascript_driver, :poltergeist_debug)
      default[:js] = true
    else
      Capybara.javascript_driver = default.fetch(:javascript_driver, :poltergeist)
    end

    if ENV['LOCAL']
      Capybara.current_driver = default.fetch(:javascript_driver, :poltergeist_debug)
    end
    default
  end
end

