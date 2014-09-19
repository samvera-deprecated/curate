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
  attribute :no_editors, Boolean

  delegate :add_member, to: :group
  delegate :group_read_membership, to: :group
  delegate :group_edit_membership, to: :group

  def group
    if self.group_id
      @group = Hydramata::Group.find(self.group_id) if( @group.nil? || @group.pid.blank? )
    else
      create_new_group_and_add_member
      self.group_id = @group.pid
    end
    @group
  end

  def person(person_id)
    @person = Person.find(person_id)
  end

  def remove_member
    group.remove_member(person)
  end

  def save
    if no_editors || !atleast_one_manager_present?
      errors.add(:no_editors, "The Group needs atleast one editor")
      false
    else
      valid? ? persist : false
    end
  end

  private

  def create_new_group_and_add_member
    @group = Hydramata::Group.new(title: self.title, description: self.description)
    @group.apply_depositor_metadata(current_user.user_key)
    @group.save
    @group.add_member(self.current_user.person, 'manager')
  end

  def atleast_one_manager_present?
    managers.select{|manager| manager if manager[:action] != "destroy"}.size >= 1
  end

  def managers
    members.select{|mem| mem if mem[:role] == "manager" }
  end

  #TODO
  # The Group object is maintaining stale value for some reason.
  # The object has to be reloaded everytime to get the consistent result.
  # I dont like this either. Hope this will get refactored when curate goes through refactoring.
  # Scenario where I found this:
  # When a member is removed from the group and immediately added back in the same update, then
  # the member is removed but not added back (even though it was added back).
  def persist
    group.title = self.title
    group.description = self.description
    group.save
    self.members.each do |member|
      group.reload
      if member[:action] == 'create'
        add_member( person( member[:person_id] ), member[:role] )
      elsif member[:action] == 'destroy'
        group.remove_member( person( member[:person_id] ) )
      elsif member[:action] == 'none'
        if member[:role] == 'manager'
          group_edit_membership( person( member[:person_id] ) )
        elsif !member[:person_id].blank?
          group_read_membership( person( member[:person_id] ) )
        end
      end
    end
  end
end
