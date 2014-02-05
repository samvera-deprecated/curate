class Organization < ActiveFedora::Base
  include Hydra::Collection
  include CurationConcern::CollectionModel
  include Hydra::AccessControls::Permissions
  include Hydra::AccessControls::WithAccessRight
  include Sufia::Noid

  # An organization cannot be a member of any other type of collection.
  def can_be_member_of_collection?(collection)
    false
  end

  def to_s
    title
  end

end
