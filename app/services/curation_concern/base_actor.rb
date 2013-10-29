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

    attr_reader :visibility
    protected :visibility

    delegate :visibility_changed?, to: :curation_concern

    def create
      apply_creation_data_to_curation_concern
      apply_save_data_to_curation_concern
      save
    end

    def update
      apply_update_data_to_curation_concern
      apply_save_data_to_curation_concern
      save
    end

    protected
    def apply_creation_data_to_curation_concern
      apply_depositor_metadata
      apply_owner_metadata
      apply_deposit_date
    end

    def apply_update_data_to_curation_concern
      true
    end

    def apply_depositor_metadata
      curation_concern.apply_depositor_metadata(user.user_key)
    end

    def apply_deposit_date
      curation_concern.date_uploaded = Date.today
    end

    def save
      curation_concern.extend(CurationConcern::RemotelyIdentifiedByDoi::MintingBehavior)
      curation_concern.apply_doi_assignment_strategy do |*|
        curation_concern.save
      end
    end

    def apply_save_data_to_curation_concern
      curation_concern.attributes = attributes
      curation_concern.date_modified = Date.today
    end

    def attach_file(generic_file, file_to_attach)
      ActiveSupport::Deprecation.warn("removing #{self.class}#attach_file, use CurationConcern.attach_file instead")
      CurationConcern.attach_file(generic_file, user, file_to_attach)
    end


    # Set the owner metadata field to the value supplied in the attributes if
    # the current user is allowed to deposit on behalf of the supplied owner.
    # Grants edit access to the owner.
    # This also deletes the owner key from the attributes so that it isn't
    # set again later when apply_save_data_to_curation_concern is called.
    def apply_owner_metadata
      owner = owner_from_attributes || user
      curation_concern.edit_users += [owner.user_key]
      curation_concern.owner = owner.user_key
    end

    def owner_from_attributes
      owner = candidate_owner
      owner if owner && user.can_make_deposits_for.include?(owner)
    end

    def candidate_owner
      attributes.has_key?('owner') && User.find_by_user_key(attributes.delete('owner'))
    end
  end
end
