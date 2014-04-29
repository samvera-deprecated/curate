module Curate
  module MigrationServices
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
        @content_model_name ||= Curate::MigrationServices.determine_best_active_fedora_model(active_fedora_object).to_s
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