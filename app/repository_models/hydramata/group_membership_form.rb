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
    if no_editors
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
    @group.add_member(self.current_user.person, 'editor')
  end

  def persist
    self.group.title = self.title
    self.group.description = self.description
    self.members.each do |member|
      if member[:action] == 'create'
        self.group.add_member( person( member[:person_id] ), member[:role] )
      elsif member[:action] == 'destroy'
        self.group.remove_member( person( member[:person_id] ) )
      elsif member[:action] == 'none'
        if member[:role] == 'manager'
          self.group.group_edit_membership( person( member[:person_id] ) )
        elsif !member[:person_id].blank?
          self.group.group_read_membership( person( member[:person_id] ) )
        end
      end
    end
    self.group.save
  end
end
