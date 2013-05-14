module Curate
  class Engine < ::Rails::Engine
    def paths
      @curate_paths ||= begin
        super_paths = super
        super_paths.add "app/repository_datastreams", eager_load: true
        super_paths.add "app/repository_models", eager_load: true
        super_paths.add "app/repository_models/curation_concern", eager_load: true
        super_paths.add "app/services", eager_load: true
        super_paths.add "app/validators", eager_load: true
        super_paths.add "app/workers", eager_load: true
        super_paths.add "app/inputs", eager_load: true
        super_paths.add "app/mailers", eager_load: true
        super_paths.add "app/builders", eager_load: true
        super_paths
      end
    end

    autoload :CatalogController, File.expand_path('../../../app/controllers/catalog_controller', __FILE__)
    autoload :ApplicationController, File.expand_path('../../../app/controllers/application_controller', __FILE__)

    config.action_dispatch.rescue_responses["ActionController::RoutingError"] = :not_found
    config.action_dispatch.rescue_responses["ActiveFedora::ObjectNotFoundError"] = :not_found
    config.action_dispatch.rescue_responses["ActiveFedora::ActiveObjectNotFoundError"] = :not_found
    config.action_dispatch.rescue_responses["Hydra::AccessDenied"] = :unauthorized
    config.action_dispatch.rescue_responses["CanCan::AccessDenied"] = :unauthorized
    config.action_dispatch.rescue_responses["Rubydora::RecordNotFound"] = :not_found

    initializer "curate" do |app|

      require File.expand_path('../../../app/repository_models/generic_file', __FILE__)
      require File.expand_path('../../../app/models/solr_document', __FILE__)
      require File.expand_path('../../../app/builders/accordion_builder_helper', __FILE__)

      require File.expand_path('../../../app/controllers/downloads_controller', __FILE__)
      require File.expand_path('../../../app/controllers/errors_controller', __FILE__)
      require File.expand_path('../../../app/builders/bootstrap_breadcrumbs_builder', __FILE__)
      require File.expand_path('../../../app/services/curation_concern', __FILE__)

      require File.expand_path('../../../app/helpers/blacklight_helper', __FILE__)
      require File.expand_path('../../../app/services/curation_concern', __FILE__)

    end
  end
end
