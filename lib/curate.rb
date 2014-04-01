require 'sufia/models'
require 'chronic'
require "curate/engine"
require "curate/configuration"
require "curate/date_formatter"
require 'simple_form'
require 'bootstrap-datepicker-rails'
require 'hydra-batch-edit'
require 'active_fedora/registered_attributes'
require 'hydra/remote_identifier'
require 'inline_reflection'
require 'contributors_association'
require 'rails_autolink'
require 'browse-everything'

module Curate
  extend ActiveSupport::Autoload
  autoload :Ability

  delegate :application_root_url, to: :configuration

  module_function
  def permanent_url_for(object)
    File.join(Curate.configuration.application_root_url, 'show', object.noid)
  end

end
