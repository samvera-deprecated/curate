class Collection < ActiveFedora::Base
  include CurationConcern::CollectionModel
  include Hydra::Collections::Collectible

  def can_be_member_of_collection?(collection)
    collection == self ? false : true
  end
end
