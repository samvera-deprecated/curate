module CurationConcern
  module WithRelatedWorks
    extend ActiveSupport::Concern

    included do
      # Should use somethign like http://purl.org/dc/elements/1.1/relation
      # -- waiting for ability to modify AF predicates (which is in another branch right now).  Using :has_member until then.
      has_and_belongs_to_many :related_works, property: :has_member, class_name:"ActiveFedora::Base"
      has_many :referenced_by_works, property: :has_member, class_name:"ActiveFedora::Base"

      accepts_nested_attributes_for :related_works, :allow_destroy => true
    end

  end
end
