class ProfileSection < ActiveFedora::Base
  include Hydra::Collection
  include Hydra::Collections::Collectible
  include CurationConcern::CollectionModel
  before_create :set_visibility_to_open_access

  def can_be_member_of_collection?(collection)
    collection.is_a?(Profile)
  end

  def set_visibility_to_open_access
    self.visibility = Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
  end
end
