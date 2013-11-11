module CurationConcern
  module CollectionModel
    extend ActiveSupport::Concern

    included do
      include Hydra::Collection
      include Hydra::AccessControls::Permissions
      include Hydra::AccessControls::WithAccessRight
      include Sufia::Noid
      include CurationConcern::HumanReadableType
      include InstanceMethods # Because methods are defined before included; which means Hydra::Collection's remove_member is showing up first
    end

    module InstanceMethods

      def add_member(collectible)
        if can_add_to_members?(collectible)
          self.members << collectible
          self.save
        end
      end

      def remove_member(collectible)
        return false unless self.members.include?(collectible)
        self.members.delete(collectible)
        self.save
      end

      def to_s
        self.title.present? ? title : inspect
      end

      def to_solr(solr_doc={}, opts={})
        super
        Solrizer.set_field(solr_doc, 'generic_type', human_readable_type, :facetable)
        solr_doc
      end

      # ------------------------------------------------
      # overriding method from active-fedora:
      # lib/active_fedora/semantic_node.rb
      #
      # The purpose of this override is to ensure that
      # a collection cannot contain itself.
      #
      # TODO:  After active-fedora 7.0 is released, this
      # logic can be moved into a before_add callback.
      # ------------------------------------------------
      def add_relationship(predicate, target, literal=false)
        return if self == target
        super
      end

      private
      def can_add_to_members?(collectible)
        collectible.can_be_member_of_collection?(self)
      rescue NoMethodError
        false
      end

    end
  end
end
