class Organization < ActiveFedora::Base
  include Hydra::Collection

  def add_member(collectible)
    return false unless collectible.respond_to?(:user)
    self.members << collectible
    self.save
  end

  def remove_member(collectible)
    return false unless self.members.include?(collectible)
    self.members.delete(collectible)
    self.save
  end

  def to_s
    self.title.present? ? title : "No Title"
  end

  def human_readable_type
    "Organization"
  end

end
