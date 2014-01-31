class ProfileSection < ActiveFedora::Base
  include Hydra::Collection
  include Hydra::Collections::Collectible
  include CurationConcern::CollectionModel

  def can_be_member_of_collection?(collection)
    return false if collection.is_a?(Organization)
    collection.is_a?(Profile)
  end
end
