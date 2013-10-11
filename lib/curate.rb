require 'sufia/models'
require "curate/engine"
require "curate/configuration"
require 'simple_form'
require 'bootstrap-datepicker-rails'
require 'hydra-batch-edit'
require 'active_fedora/registered_attributes'
require 'hydra/remote_identifier'
require 'inline_reflection'
require 'contributors_association'

module Curate
  extend ActiveSupport::Autoload
  autoload :Ability
end
