module Curate
  module MigrationServices
    module MigrationContainers
      module DisplayName
        class BaseMigrator < Curate::MigrationServices::BaseMigrator
        end

        class PersonMigrator < BaseMigrator
          # This is what the datastream used to look like
          class FromDescMetadata < ActiveFedora::QualifiedDublinCoreDatastream
            def initialize(*args)
              super
              field :display_name, :string
              field :preferred_email, :string
              field :alternate_email, :string
            end
          end

          def migrate
            active_fedora_object.datastreams.each do |ds_name, ds_object|
              if ds_name == 'descMetadata'
                migrate_desc_metadata(ds_name, ds_object)
              end
            end
            super
          end

          private

          # Migrating from a QualifiedDublinCoreDatastream to an RdfNTriplesDatastream
          def migrate_desc_metadata(ds_name, ds_object)
            from = FromDescMetadata.new(rubydora_object, ds_name)
            to = PersonMetadataDatastream.new(build_unsaved_digital_object, ds_name)
            begin
              to.name = from.display_name if from.display_name.present?
              to.email = from.preferred_email if from.preferred_email.present?
              to.alternate_email = from.alternate_email if from.alternate_email.present?
              to.save
            rescue Nokogiri::XML::XPath::SyntaxError
              # already converted
              true
            end
          end

          # Assumes application is running at application URL
          def visit
            remote_url = File.join(Rails.configuration.application_root_url, "people/#{rubydora_object.pid}")
            RestClient.get(remote_url, content_type: :html, accept: :html, verify_ssl: OpenSSL::SSL::VERIFY_NONE) do |response, request, result, &block|
              if [301, 302, 307].include? response.code
                response.follow_redirection(request, result, &block)
              else
                response.return!(request, result, &block)
              end
            end
          end
        end
      end
    end
  end
end
