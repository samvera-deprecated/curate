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
      @attributes = input_attributes.dup
      @visibility = attributes[:visibility]
    end

    def create!
      apply_creation_data_to_curation_concern
      save!
    end

    def create
      apply_creation_data_to_curation_concern
      save
    end

    def apply_creation_data_to_curation_concern
      curation_concern.apply_depositor_metadata(user.user_key)
      curation_concern.creator = user.name
      curation_concern.date_uploaded = Date.today
    end
    protected :apply_creation_data_to_curation_concern

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
      #curation_concern.visibility = visibility
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
