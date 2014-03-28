module Curate
  module MigrationServices
    class UnsavedDigitalObject < ActiveFedora::UnsavedDigitalObject
      attr_reader :repository
      def initialize(repository, *args, &block)
        @repository = repository
        super(*args, &block)
      end
    end
  end
end
