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

  end
end

require 'curate/migration_services/migration_containers'