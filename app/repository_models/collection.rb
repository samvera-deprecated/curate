class Collection < ActiveFedora::Base
  include Hydra::Collection
  include CurationConcern::CollectionModel
  include Hydra::Collections::Collectible

  def can_be_member_of_collection?(collection)
    return false if collection.is_a?(Organization)
    collection == self ? false : true
  end
end
