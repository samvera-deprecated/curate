module Curate::OrganizationsHelper

  # Displays the Organizations create organization button.
  def button_for_create_new_organization(label = 'Create Organization')
    render partial: 'button_create_organization', locals:{label:label}
  end

  def has_any_organizations?
    #false
    current_user.organizations.count > 0 if current_user
  end

end
