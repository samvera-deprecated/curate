require 'sufia/models'
require "curate/engine"
require "curate/configuration"
require 'simple_form'
require 'bootstrap-datepicker-rails'
require 'hydra-batch-edit'
require 'active_fedora/registered_attributes'

module Curate
  extend ActiveSupport::Autoload
  autoload :Ability
  autoload :User
end
