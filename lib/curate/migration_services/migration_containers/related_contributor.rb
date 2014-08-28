module Curate
  module MigrationServices
    module MigrationContainers
      module RelatedContributor
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
            prefix = %(<info:fedora/#{ds_object.pid}> <http://purl.org/dc/terms/creator>)
            regexp = /^#{Regexp.escape(prefix)} \<info:fedora\/([^\>]*)\> \.$/
            modified_content = content.split("\n").collect do |line|
              convert_contributor!(prefix, regexp, line)
            end.compact.join("\n")

            if content != modified_content
              ds_object.content = modified_content
              ds_object.save
            end
          end

          private

          def convert_contributor!(prefix, regexp, line)
            regexp =~ line
            pid = $1
            if pid
              person = Person.find(pid)
              name = ""
              if person.name.present?
                name = person.name
              elsif user = User.where(repository_id: pid).first
                name = user.name
              else
                name = user.user_key
              end
              if name.present?
                # For some reason the UI attribute for :contributor is being
                # written to the :creator attribute
                #
                # This relates to SHA: 0d57a81d which implemented the following
                # https://github.com/ndlib/planning/issues/137
                %(#{transform_contributor_prefix(prefix)} "#{name}" .)
              else
                nil
              end
            else
              line
            end
          end

          def transform_contributor_prefix(prefix)
            prefix.sub(/\/creator/, '/contributor')
          end
        end

        (Curate.configuration.registered_curation_concern_types + ['GenericFile']).each do |work_type|
          # Pardon the crime against security. I can manually add these. But I'm
          # lazy.
          class_eval("class #{work_type}Migrator < WorkMigrator\nend")
        end

        if defined?(ImageMigrator)
          class ImageMigrator
            # In the case of Image, we've been capturing the :creator instead
            # of any semblance of :contributor
            def transform_contributor_prefix(prefix)
              prefix
            end
          end
        end
      end
    end
  end
end
