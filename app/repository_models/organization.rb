class Organization < ActiveFedora::Base
  include Hydra::Collection
  include CurationConcern::CollectionModel
  include Hydra::AccessControls::Permissions
  include Hydra::AccessControls::WithAccessRight
  include Sufia::Noid

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

  # Only a user object or a derivative of user can be a member of an Organization.
  def can_add_to_members?(collectible)
    collectible.respond_to?(:user)
  rescue NoMethodError
    false
  end

  # An organization cannot be a member of any other type of collection.
  def can_be_member_of_collection?(collection)
    false
  end

  def to_s
    title
  end

end
