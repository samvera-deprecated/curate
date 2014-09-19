Capistrano::Configuration.instance(:must_exist).load do
  namespace :curate do
    namespace :migration_services do
      # It would be nice if I could auto-generate this list, but there are
      # too many dependencies introduced in the migration services objects
      # so for now this will be how it is done.
      ['RelatedContributor', 'DisplayName', 'MetadataNormalization'].each do |namespace|
        desc "Run the #{namespace} migration service"
        task namespace.to_sym, roles: :app do
          command = "require 'curate/migration_services/runner'; Curate::MigrationServices.run(container_namespace: 'Curate::MigrationServices::MigrationContainers::#{namespace}');"
          run %(rails runner -e #{rails_env} "#{command}")
        end
      end
    end
  end
end