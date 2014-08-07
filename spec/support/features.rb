require File.expand_path('../features/session_helpers', __FILE__)
require File.expand_path('../features/create_works', __FILE__)
require File.expand_path('../curate_fixture_file_upload', __FILE__)

require 'capybara/poltergeist'

Capybara.register_driver :poltergeist_debug do |app|
  Capybara::Poltergeist::Driver.new(app, :inspector => true)
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



RSpec.configure do |config|
  config.include CurateFixtureFileUpload
  config.include Devise::TestHelpers, type: :controller
  config.include Warden::Test::Helpers, type: :feature
  config.include Features::SessionHelpers, type: :feature
  config.include Features::CreateWorks, type: :feature

  config.before(:each, type: :feature) do
    Warden.test_mode!
    @old_resque_inline_value = Resque.inline
    Resque.inline = true
  end

  config.after(:each, type: :feature) do
    Warden.test_reset!
    Resque.inline = @old_resque_inline_value
  end
end
