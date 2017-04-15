class Curate::OrganizationsController < ApplicationController
  include Blacklight::Catalog
  include Sufia::Noid

  prepend_before_filter :normalize_identifier, only: [:show]

  with_themed_layout '1_column'

  add_breadcrumb 'Organizations', lambda {|controller| controller.request.path }

  before_filter :load_and_authorize_organization, only: [:show, :edit, :delete]
  before_filter :authenticate_user!, except: :show
  before_filter :agreed_to_terms_of_service!
  before_filter :force_update_user_profile!

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(params[:organization])
    @organization.apply_depositor_metadata(current_user.user_key)
    if @organization.save
      flash[:notice] = "Organization created successfully."
      redirect_to organization_path(@organization.id)
    else
      flash[:error] = "Organization was not created."
      render action: :new
    end
  end

  def load_and_authorize_organization
    id = id_from_params(:id)
    return nil unless id
    @organization = ActiveFedora::Base.find(id, cast: true)
    authorize! :update, @organization
  end

  def id_from_params(key)
    if params[key] && !params[key].empty?
      params[key]
    end
  end
end
