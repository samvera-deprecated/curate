module Curate
  module MigrationServices
    class UnsavedDigitalObject < ActiveFedora::UnsavedDigitalObject
      attr_reader :repository
      def initialize(repository, *args, &block)
        @repository = repository
        super(*args, &block)
      end
    end

    def self.determine_best_active_fedora_model(active_fedora_object)
      if active_fedora_object.is_a?(ActiveFedora::Base)
        if ! active_fedora_object.instance_of? ActiveFedora::Base
          best_model_match = active_fedora_object.class
        end
      else
        active_fedora_object = ActiveFedora::Base.find(active_fedora_object.pid, cast: false)
      end

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


    def self.enqueue(options = {})
      Sufia.queue.push(Runner.new(options))
    end

    def self.run(*args)
      enqueue(*args)
    end

    def queue_name
      :migration_services
    end

    class Runner
      attr_reader :id_namespace, :migration_container_module_name
      def initialize(config = {})
        @migration_container_module_name = config.fetch(:migration_container_module_name)
        @id_namespace = config.fetch(:id_namespace) { Sufia.config.id_namespace }
      end

      def container_namespace
        @container_namespace ||= begin
          require 'curate/migration_services/migration_containers'
          ::Curate::MigrationServices::MigrationContainers.const_get(migration_container_module_name)
        end
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
              active_fedora_object = ActiveFedora::Base.find(rubydora_object.pid, cast: false)
              model_name = Curate::MigrationServices.determine_best_active_fedora_model(active_fedora_object)
              begin
                if build(rubydora_object, active_fedora_object, model_name).migrate
                  handler.success(rubydora_object.pid, model_name)
                else
                  handler.failure(rubydora_object.pid, model_name)
                end
              rescue Exception => e
                handler.exception(rubydora_object.pid, model_name, e)
              end
            end
          end
        end
      end

      private
      def build(rubydora_object, active_fedora_object, model_name)
        migrator_name = "#{model_name.to_s.gsub("::", "")}Migrator"
        if container_namespace.const_defined?(migrator_name)
          container_namespace.const_get(migrator_name).new(rubydora_object, active_fedora_object)
        else
          container_namespace.const_get('BaseMigrator').new(rubydora_object, active_fedora_object)
        end
      end
    end
  end
end
