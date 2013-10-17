module CurationConcern
  module DoiAssignable
    extend ActiveSupport::Concern

    included do
      unless included_modules.include?(ActiveFedora::RegisteredAttributes)
        include ActiveFedora::RegisteredAttributes
      end
      attribute :identifier,
        datastream: :descMetadata,
        multiple: false, editable: false, displayable: true
      attribute :doi_assignment_strategy,
        multiple: false, editable: true, displayable: false
      attribute :existing_identifier,
        multiple: false, editable: true, displayable: false
      before_validation :apply_doi_assignment_strategy
    end

    NOT_NOW = 'not_now'
    ALREADY_GOT_ONE = 'already_got_one'

    attr_writer :doi_remote_service
    private

    def doi_remote_service
      @doi_remote_service ||= Hydra::RemoteIdentifier.remote_service(:doi)
    end

    def apply_doi_assignment_strategy
      not_now? ||
      request_remote_minting_for ||
      update_identifier_locally
    end

    def request_remote_minting_for(value = doi_assignment_strategy)
      return false unless doi_remote_service.accessor_name.to_s == value.to_s
      doi_remote_service.mint(self)
    end

    def update_identifier_locally(value = doi_assignment_strategy)
      if doi_assignment_strategy == CurationConcern::DoiAssignable::ALREADY_GOT_ONE
        self.identifier = existing_identifier
      end
    end

    def not_now?(value = doi_assignment_strategy)
      value.to_s == CurationConcern::DoiAssignable::NOT_NOW
    end
  end
end