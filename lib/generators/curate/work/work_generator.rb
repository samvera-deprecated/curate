# -*- encoding : utf-8 -*-
require 'rails/generators'

class Rails::Generators::NamedBase
  private
  def destroy(what, *args)
    log :destroy, what
    argument = args.map {|arg| arg.to_s }.flatten.join(" ")

    in_root {
      run_ruby_script("bin/rails destroy #{what} #{argument}", verbose: true)
    }
  end
end

class Curate::WorkGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("../templates", __FILE__)


  class_option :doi, type: :boolean, default: true, desc: "Should the work provide a means of minting a DOI?"
  argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

  # Why all of these antics with defining individual methods?
  # Because I want the output of Curate::WorkGenerator to include all the processed files.
  def create_model_spec
    append_doi_initializer if register_doi?
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

  def register_work
    inject_into_file 'config/initializers/curate_config.rb', after: "Curate.configure do |config|\n" do
      data = ""
      data << "  # Injected via `rails g curate:work #{class_name}`\n"
      data << "  config.register_curation_concern :#{file_name}\n"
      data
    end
  end

  def create_views
    create_file "app/views/curation_concern/#{plural_file_name}/_#{file_name}.html.erb" do
      data = "<%# This is a search result view %>\n"
      data << "<%= render partial: 'catalog/document', locals: {document: #{file_name}, document_counter: #{file_name}_counter } %>\n"
      data
    end
  end

  def create_readme
    readme 'README'
  end

  private
  def register_doi?
    !!options['doi']
  end

  def append_doi_initializer
    args = ['curate:work:with_doi', "#{file_name}"]
    if behavior == :revoke
      destroy(*args)
    else
      generate(*args)
    end
  end
end
