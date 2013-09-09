# -*- encoding : utf-8 -*-
require 'rails/generators'

class Curate::WorkGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)

  desc "Create a Repository Model."
  argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

  # Why all of these antics with defining individual methods?
  # Because I want the output of Curate::WorkGenerator to include all the processed files.
  def create_model_spec
    template "model_spec.rb.erb", "spec/repository_models/#{file_name}_spec.rb"
  end
  def create_model
    template("model.rb.erb", "app/repository_models/#{file_name}.rb")
  end
  def create_controller_spec
    template("controller_spec.rb.erb", "spec/controllers/curation_concern/#{plural_file_name}_controller_spec.rb")
  end
  def create_actor_spec
    template("actor_spec.rb.erb", "spec/services/curation_concern/#{file_name}_actor_spec.rb")
  end
  def create_factory
    template("factory.rb.erb", "spec/factories/#{plural_file_name}_factory.rb")
  end
  def create_datastream
    template("datastream.rb.erb", "app/repository_datastreams/#{file_name}_rdf_datastream.rb")
  end
  def create_controller
    template("controller.rb.erb", "app/controllers/curation_concern/#{plural_file_name}_controller.rb")
  end
  def create_actor
    template("actor.rb.erb", "app/services/curation_concern/#{file_name}_actor.rb")
  end

  def update_routes
    reg_exp = /^(\s+curate_for\(? *\{? *:?containers:? *=?\>? *\[)([^\]]*)(\] *\}? *\)?)\s*$/
    gsub_file 'config/routes.rb', reg_exp do |match|
      match =~ reg_exp
      # Don't re-add the route
      if !$2.include?(plural_table_name)
        match = $1 << $2 << ", :#{plural_table_name}" << $3
      end
      match
    end
  end

  def register_work
    inject_into_file 'config/initializers/curate_config.rb', after: "Curate.configure do |config|\n" do
      data = ""
      data << "  # Injected via `rails g curate:work #{class_name}`\n"
      data << "  config.register_curation_concern :#{file_name}\n"
      data
    end
  end

  # def create_views
  # end
end
