require 'curate/migration_services/base_migrator'
module Curate
  module MigrationServices
    module MigrationContainers
      module MetadataNormalization

        class BaseMigrator < Curate::MigrationServices::BaseMigrator
          attr_writer :transformer
          def transformer
            @transformer ||= begin
              require 'curate/migration_services/transformers/metadata_transformer'
              Curate::MigrationServices::Transformers::MetadataTransformer
            end
          end
        end

        class WorkMigrator < BaseMigrator
          def migrate
            active_fedora_object.datastreams.each do |ds_name, ds_object|
              if ds_name == 'descMetadata'
                migrate_desc_metadata(ds_name, ds_object)
              end
            end
            super
          end
          def migrate_desc_metadata(ds_name, ds_object)
            content = ds_object.content
            modified_content = transformer.call(content_model_name, ds_object.pid, content)
            if content != modified_content
              ds_object.content = modified_content
              ds_object.save
            end
          end
        end

        if Curate.respond_to?(:configuration)
          (Curate.configuration.registered_curation_concern_types + ['GenericFile']).each do |work_type|
            # Pardon the crime against security. I can manually add these. But I'm
            # lazy.
            class_eval("class #{work_type}Migrator < WorkMigrator\nend")
          end
        end
      end
    end
  end
end
