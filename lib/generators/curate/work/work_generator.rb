# -*- encoding : utf-8 -*-
require 'rails/generators'

class Curate::WorkGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)

  desc "Create a Repository Model."

  def create_repository_model
    template "model.rb.erb", "app/repository_models/#{file_name}.rb"
    template "model_spec.rb.erb", "spec/repository_models/#{file_name}_spec.rb"
  end

  # def create_controller
  #   template "controller.rb.erb", "app/controllers/curation_concern/#{plural_file_name}_actor.rb"
  #   template "controller_spec.rb.erb", "spec/controllers/curation_concern/#{plural_file_name}_actor.rb"
  # end

  def create_actor
    template "actor.rb.erb", "app/services/curation_concern/#{file_name}_actor.rb"
    template "actor_spec.rb.erb", "spec/services/curation_concern/#{file_name}_actor.rb"
  end

  def create_factory
    template "factory.rb.erb", "spec/factories/#{plural_file_name}_factory.rb"
  end

  # def create_views
  # end
end
