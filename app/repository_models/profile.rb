class Profile < ActiveFedora::Base
  include Hydra::Collection
  include CurationConcern::CollectionModel

  has_many :associated_persons, property: :has_profile, class_name: 'Person'

end
