module Curate
  module MigrationServices
    module MigrationContainers
      module MetadataNormalization
        class BaseMigrator < Curate::MigrationServices::BaseMigrator
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
            content = ds_object.content.dup
            modified_content = content.split("\n").collect do |line|
              tansform(ds_object, line)
            end.join("\n")

            if content != modified_content
              ds_object.content = modified_content
              ds_object.save
            end
          end
          def transform(ds_object, line)
            return line
            # prefix = %(<info:fedora/#{ds_object.pid}> <http://purl.org/dc/terms/creator>)
            # regexp = /^#{Regexp.escape(prefix)} \<info:fedora\/([^\>]*)\> \.$/
          end
        end

        (Curate.configuration.registered_curation_concern_types + ['GenericFile']).each do |work_type|
          # Pardon the crime against security. I can manually add these. But I'm
          # lazy.
          class_eval("class #{work_type}Migrator < WorkMigrator\nend")
        end

      end
    end
  end
end
