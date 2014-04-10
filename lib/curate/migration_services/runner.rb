module Curate
  module MigrationServices
    module_function
    def determine_best_active_fedora_model(active_fedora_object)
      best_model_match = active_fedora_object.class unless active_fedora_object.instance_of? ActiveFedora::Base
      ActiveFedora::ContentModel.known_models_for(active_fedora_object).each do |model_value|
        # If this is of type ActiveFedora::Base, then set to the first found :has_model.
        best_model_match ||= model_value

        # If there is an inheritance structure, use the most specific case.
        if best_model_match > model_value
          best_model_match = model_value
        end
      end
      best_model_match
    end

    def run(*args)
      Runner.enqueue(*args)
    end

    class Runner

      def self.enqueue(*args)
        Sufia.queue.push(self.new(*args))
      end

      def queue_name
        :migrator
      end

      attr_reader :id_namespace
      def initialize(config = {})
        @container_namespace = config.fetch(:container_namespace) { '::Curate::MigrationServices::MigrationContainers::DisplayName' }
        @id_namespace = config.fetch(:id_namespace) { Sufia.config.id_namespace }
      end

      def container_namespace
        @container_namespace.constantize
      end

      def logger
        @logger ||= begin
          require 'curate/migration_services/logger'
          Logger.new
        end
      end

      def run
        logger.around("Runner#run") do |handler|
          ActiveFedora::Base.send(:connections).each do |connection|
            results = connection.search("pid~#{id_namespace}:*")
            results.each do |rubydora_object|
              begin
                if build(rubydora_object, container_namespace).migrate
                  handler.success(rubydora_object.pid)
                else
                  handler.failure(rubydora_object.pid)
                end
              rescue Exception => e
                handler.exception(rubydora_object.pid, e)
              end
            end
          end
        end
      end

      private

      def build(rubydora_object, container_namespace)
        active_fedora_object = ActiveFedora::Base.find(rubydora_object.pid, cast: false)
        best_model_match = Curate::MigrationServices.determine_best_active_fedora_model(active_fedora_object)

        migrator_name = "#{best_model_match.to_s.gsub("::", "")}Migrator"
        if container_namespace.const_defined?(migrator_name)
          container_namespace.const_get(migrator_name).new(rubydora_object, active_fedora_object)
        else
          container_namespace.const_get('BaseMigrator').new(rubydora_object, active_fedora_object)
        end
      end

    end

    class BaseMigrator
      attr_reader :rubydora_object, :active_fedora_object

      def initialize(rubydora_object, active_fedora_object)
        @rubydora_object = rubydora_object
        @active_fedora_object = active_fedora_object
      end

      def migrate
        load_datastreams &&
          update_index &&
          visit
      end

      def inspect
        "#<#{self.class.inspect} content_model_name:#{content_model_name.inspect} pid:#{rubydora_object.pid.inspect}>"
      end

      def content_model_name
        Curate::MigrationServices.determine_best_active_fedora_model(active_fedora_object).to_s
      end

      protected

      def build_unsaved_digital_object
        Curate::MigrationServices::UnsavedDigitalObject.new(rubydora_object.repository, active_fedora_object.class, 'und', rubydora_object.pid)
      end

      def load_datastreams
        # A rudimentary check to see if the object's datastreams can be loaded
        model_object.datastreams.each {|ds_name, ds_object| ds_object.inspect }
      end

      def update_index
        model_object.update_index
      end

      def model_object
        @model_object = ActiveFedora::Base.find(rubydora_object.pid, cast: true)
      end

      def visit
        true
      end
    end

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
                name = user.email
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
