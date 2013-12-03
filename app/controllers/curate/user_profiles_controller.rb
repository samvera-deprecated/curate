class Curate::UserProfilesController < ApplicationController

  before_filter :authenticate_user!

  def show
    if current_user.repository_id.present?
      redirect_to person_path(current_user.person)
    else
      redirect_to edit_user_registration_path
    end
  end

end
