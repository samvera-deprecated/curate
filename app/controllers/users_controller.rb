class UsersController < ApplicationController
  include Curate::ThemedLayoutController
  with_themed_layout '1_column'

  def edit
    render 'registrations/edit'
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.find(params[:id])
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  helper_method :resource_name, :resource, :devise_mapping

end
