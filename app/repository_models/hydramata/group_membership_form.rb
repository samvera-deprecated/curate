require 'virtus'
class Hydramata::GroupMembershipForm
  include Virtus.model
  include ActiveModel::Validations
  extend ActiveModel::Naming

  attribute :current_user, User
  attribute :group_id, String
  attribute :title, String
  attribute :description, String
  attribute :members, Array
  validates :group_id, presence: true

  def group
    @group ||= Hydramata::Group.find(group_id) 
  rescue ActiveFedora::ObjectNotFoundError
    Hydramata::Group.new
  end

  def person(person_id)
    @person = Person.find(person_id)
  end

  def add_member(role)
    group.add_member(person, role)
  end

  def remove_member
    group.remove_member(person)
  end

  def save
    valid? ? persist : false
  end

  private
  def persist
    group.title = self.title
    group.description = self.description
    self.members.each do |member|
      if member[:action] == 'create'
        group.add_member( person( member[:person_id] ), member[:role] )
      elsif member[:action] == 'destroy'
        group.remove_member( person( member[:person_id] ) )
      elsif member[:action] == 'none'
        if member[:role] == 'manager'
          group.group_edit_membership( person( member[:person_id] ) )
        elsif !member[:person_id].blank?
          group.group_read_membership( person( member[:person_id] ) )
        end
      end
    end
    group.save
  end
end
