module CurationConcern
  # The CurationConcern base actor should respond to three primary actions:
  # * #create
  # * #update
  # * #delete
  class BaseActor
    attr_reader :curation_concern, :user, :attributes
    def initialize(curation_concern, user, input_attributes)
      @curation_concern = curation_concern
      @user = user
      @attributes = input_attributes.dup.with_indifferent_access
      @visibility = attributes[:visibility]
    end

    def create!
      apply_creation_data_to_curation_concern
      save! && assign_remote_identifiers_if_applicable
    end

    def create
      apply_creation_data_to_curation_concern
      save && assign_remote_identifiers_if_applicable
    end

    def apply_creation_data_to_curation_concern
      curation_concern.apply_depositor_metadata(user.user_key)
      curation_concern.owner = attributes.delete('owner') || user.user_key
      curation_concern.date_uploaded = Date.today
    end
    protected :apply_creation_data_to_curation_concern

    def assign_remote_identifiers_if_applicable
      Hydra::RemoteIdentifier.requested_remote_identifiers_for(curation_concern) do |remote_service|
        MintRemoteIdentifierWorker.enqueue(curation_concern.pid, remote_service.name)
      end
      true # included to make sure save chaining can occur
    end

    def update!
      save!
    end

    def update
      save
    end

    def save!
      apply_save_data_to_curation_concern
      curation_concern.save!
    end
    protected :save!

    def save
      apply_save_data_to_curation_concern
      curation_concern.save
    end
    protected :save

    def apply_save_data_to_curation_concern
      curation_concern.attributes = attributes
      curation_concern.date_modified = Date.today
    end
    protected :apply_save_data_to_curation_concern

    attr_reader :visibility
    protected :visibility

    delegate :visibility_changed?, to: :curation_concern

    def attach_file(generic_file, file_to_attach)
      ActiveSupport::Deprecation.warn("removing #{self.class}#attach_file, use CurationConcern.attach_file instead")
      CurationConcern.attach_file(generic_file, user, file_to_attach)
    end
    protected :attach_file
  end
end
