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
        multiple: false, editable: true, displayable: false, writer: :apply_doi_assignment_strategy
    end

    def not_now_value_for_doi_assignment
      'not_now'
    end

    attr_writer :doi_remote_service
    private
    def doi_remote_service
      @doi_remote_service ||= Hydra::RemoteIdentifier.remote_service(:doi)
    end

    def apply_doi_assignment_strategy(value)
      not_now?(value) ||
      request_remote_minting_for(value) ||
      update_identifier_locally(value)
    end

    def request_remote_minting_for(value)
      return false unless doi_remote_service.accessor_name.to_s == value.to_s
      doi_remote_service.mint(self)
    end

    def update_identifier_locally(value)
      self.identifier = value
    end

    def not_now?(value)
      value.to_s == not_now_value_for_doi_assignment
    end
  end
end