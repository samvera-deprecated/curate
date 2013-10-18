module CurationConcern
  module RemotelyIdentifiedByDoi

    NOT_NOW = 'not_now'
    ALREADY_GOT_ONE = 'already_got_one'

    # What does it mean to be remotely assignable; Exposing the attributes
    module Attributes
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
      end
    end

    module MintingBehavior
      def apply_doi_assignment_strategy(&perform_persistence_block)
        if respond_to?(:doi_assignment_strategy)
          no_doi_assignment_strategy_given(&perform_persistence_block) ||
            not_now(&perform_persistence_block) ||
            update_identifier_locally(&perform_persistence_block) ||
            request_remote_minting_for(&perform_persistence_block)
        else
          !!yield(self)
        end
      end

      attr_writer :doi_remote_service

      private

      def doi_remote_service
        @doi_remote_service ||= Hydra::RemoteIdentifier.remote_service(:doi)
      end

      def request_remote_minting_for
        return false unless doi_remote_service.accessor_name.to_s == doi_assignment_strategy.to_s
        # Before we make a potentially expensive call
        # hand off control back to the caller.
        # I'm doing this because I want a chance to persist the object first
        !!yield(self) && doi_remote_service.mint(self)
      end

      def update_identifier_locally
        return false unless doi_assignment_strategy == CurationConcern::RemotelyIdentifiedByDoi::ALREADY_GOT_ONE
        # I'm doing this because before I persist, I want to update the
        # identifier
        self.identifier = existing_identifier
        !!yield(self)
      end

      def no_doi_assignment_strategy_given
        return false unless doi_assignment_strategy.blank?
        !!yield(self)
      end

      def not_now
        return false unless doi_assignment_strategy.to_s == CurationConcern::RemotelyIdentifiedByDoi::NOT_NOW
        !!yield(self)
      end
    end
  end
end
