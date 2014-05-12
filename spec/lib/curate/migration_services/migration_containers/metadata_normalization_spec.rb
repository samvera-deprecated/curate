require 'curate/migration_services/migration_containers/metadata_normalization'
require 'curate/migration_services/transformers/metadata_transformer'
require 'spec_helper'

module Curate
  module MigrationServices
    module MigrationContainers
      module MetadataNormalization
        describe BaseMigrator do
          let(:rubydora) { double("Rubydora")}
          let(:active_fedora) { double("ActiveFedora")}
          subject { described_class.new(rubydora, active_fedora) }
          its(:transformer) { should eq Curate::MigrationServices::Transformers::MetadataTransformer }
        end
      end
    end
  end
end
