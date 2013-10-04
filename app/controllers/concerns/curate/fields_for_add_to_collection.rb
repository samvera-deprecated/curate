module Curate::FieldsForAddToCollection
  extend ActiveSupport::Concern

protected

  def collection_options
    @collection_options ||= current_users_collections
  end

  def profile_collection_options
    @profile_collection_options ||= current_users_profile_sections
  end

  def current_users_collections
    current_user ? current_user.collections.to_a : []
  end

  def current_users_profile_sections
    return [] unless current_user
    return [] unless current_user.profile
    options = current_user.profile.members.select{ |item|
      item.is_a?(Collection) && can?(:edit, item)
    }
    options = options.unshift(current_user.profile)
  end

end
