module Hydramata::GroupsHelper

  # Displays the create group button.
  def button_for_create_new_group(label = 'Create Group')
    render partial: 'button_create_group', locals:{label:label}
  end

  def has_any_group?
    current_user.person.groups.count > 0 if current_user
  end

end
