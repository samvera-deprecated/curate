class CurationConcern::SeniorThesesController < ApplicationController
  respond_to(:html)
  layout 'curate_nd'
  include Sufia::Noid # for normalize_identifier method

  before_filter :authenticate_user!, :except => [:show, :citation]
  before_filter :has_access?, :except => [:show]
  prepend_before_filter :normalize_identifier, :except => [:index, :create, :new]
  load_and_authorize_resource :except=>[:index, :audit]

  # Catch permission errors
  rescue_from Hydra::AccessDenied, CanCan::AccessDenied do |exception|
    if (exception.action == :edit)
      redirect_to(url_for({:action=>'show'}), :alert => "You do not have sufficient privileges to edit this document")
    elsif current_user and current_user.persisted?
      redirect_to root_url, :alert => exception.message
    else
      session["user_return_to"] = request.url
      redirect_to new_user_session_url, :alert => exception.message
    end
  end

  attr_reader :senior_thesis
  helper_method :senior_thesis

  def new
    @senior_thesis = SeniorThesis.new(params[:senior_thesis])
  end

  def create
    @senior_thesis = SeniorThesis.new(pid: CurationConcern.mint_a_pid)
    CurationConcern::Actions.create_metadata(@senior_thesis, current_user, params[:senior_thesis])
    respond_with([:curation_concern,@senior_thesis])
  rescue ActiveFedora::RecordInvalid
    respond_with([:curation_concern, @senior_thesis]) do |wants|
      wants.html { render 'new', status: :unprocessable_entity }
    end
  end

  def show
    @senior_thesis = SeniorThesis.find(params[:id])
    respond_with(@senior_thesis)
  end

  def edit
    @senior_thesis = SeniorThesis.find(params[:id])
    respond_with(@senior_thesis)
  end

  def update
    @senior_thesis = SeniorThesis.find(params[:id])
    CurationConcern::Actions.update_metadata(@senior_thesis, current_user, params[:senior_thesis])
    respond_with([:curation_concern, @senior_thesis])
  rescue ActiveFedora::RecordInvalid
    respond_with([:curation_concern, @senior_thesis]) do |wants|
      wants.html { render 'edit', status: :unprocessable_entity }
    end
  end

  def destroy
  end

end
