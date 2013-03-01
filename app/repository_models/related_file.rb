# This is not a Fedora object but is present to help negotiate
# the Fedora object relation.
class RelatedFile
  include ActiveAttr::Model

  attribute :parent_curation_concern_id
  attribute :file
  attribute :title
end