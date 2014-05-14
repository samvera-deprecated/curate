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

        validates :publisher, multi_value_presence: { message: 'is required for remote DOI minting', if: :remote_doi_assignment_strategy? }

        attr_writer :doi_remote_service

        protected

        def doi_remote_service
          @doi_remote_service ||= Hydra::RemoteIdentifier.remote_service(:doi)
        end

        def remote_doi_assignment_strategy?
          doi_assignment_strategy.to_s == doi_remote_service.accessor_name.to_s
        end
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


      private

      def request_remote_minting_for
        return false unless remote_doi_assignment_strategy?
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
