class Hydramata::Group < ActiveFedora::Base
  include Sufia::ModelMethods
  include CurationConcern::HumanReadableType
  include Hydra::AccessControls::Permissions
  include Sufia::Noid

  has_metadata 'properties', type: Curate::PropertiesDatastream
  has_attributes :relative_path, :depositor, :owner, datastream: :properties, multiple: false
  class_attribute :human_readable_short_description

  has_and_belongs_to_many :members, class_name: "::Person", property: :has_member, inverse_of: :is_member_of
  has_and_belongs_to_many :works, class_name: "::ActiveFedora::Base", property: :is_editor_group_of, inverse_of: :has_editor_group
  has_metadata "descMetadata", type: GroupMetadataDatastream
  accepts_nested_attributes_for :members, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :works, allow_destroy: true, reject_if: :all_blank

  has_attributes :title, :date_uploaded, :date_modified, :description, datastream: :descMetadata, multiple: false
  validate :title_is_unique

  def title_is_unique
    errors.add(:title, "has already been taken") if is_title_duplicate?
  end

  def is_title_duplicate?
    Hydramata::Group.where(desc_metadata__title_tesim: self.title).to_a.reject{|r| r == self}.any?
  end

  def add_member(candidate, role='')
    return if(!candidate.is_a?(Person) or self.members.include?(candidate))
    self.add_relationship(:has_member, candidate)
    self.save!
    candidate.add_relationship(:is_member_of, self)
    candidate.save!
    self.create_role(candidate, role)
  end

  def remove_member(candidate)
    return unless(self.members.include?(candidate) && (self.depositor != candidate.depositor))
    candidate.remove_relationship(:is_member_of, self)
    candidate.save!
    self.remove_relationship(:has_member, candidate)
    self.save!
    self.remove_member_privileges(candidate)
  end
  
  def to_s
    title
  end

  def can_be_member_of_collection?(collection)
    false
  end

  def create_role(candidate, role)
    if role == 'manager'
      self.group_edit_membership(candidate)
    else
      self.group_read_membership(candidate)
    end
  end

  def group_edit_membership(candidate)
    self.read_users.delete(candidate.depositor) if self.read_users.include?(candidate.depositor)
    self.permissions_attributes = [{name: candidate.depositor, access: "edit", type: "person"}]
    self.save!
  rescue ActiveFedora::RecordInvalid => e
    errors.add(:title, e.message)
  end

  def group_read_membership(candidate)
    unless self.depositor == candidate.depositor
      self.edit_users.delete(candidate.depositor) if self.edit_users.include?(candidate.depositor)
      self.permissions_attributes = [{name: candidate.depositor, access: "read", type: "person"}]
      self.save!
    end
  end

  def remove_member_privileges(candidate)
    unless self.depositor == candidate.depositor
      self.edit_users = self.edit_users - [candidate.depositor] if self.edit_users.include?(candidate.depositor)
      self.read_users = self.read_users - [candidate.depositor] if self.read_users.include?(candidate.depositor)
      self.save!
    end
  end

end
