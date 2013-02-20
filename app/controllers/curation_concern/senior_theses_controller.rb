class CurationConcern::SeniorThesesController < ApplicationController
  respond_to(:html)
  expose(:senior_thesis, model: SeniorThesis)
  include Sufia::Noid

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

  def new
    @noid = Sufia::Noid.noidify(Sufia::IdService.mint)
    @senior_thesis = SeniorThesis.new
  end

  def create
    begin
      @senior_thesis = SeniorThesis.find_or_create(Sufia::Noid.namespaceize(params[:id]))
      CurationConcern::Actions.create_metadata(@senior_thesis, current_user, params)
      flash[:notice] = 'Your files are being processed by ' + t('sufia.product_name') + ' in the background. The metadata and access controls you specified are being applied. Files will be marked <span class="label label-important" title="Private">Private</span> until this process is complete (shouldn\'t take too long, hang in there!). You may need to refresh your dashboard to see these updates.'
      redirect_to sufia.dashboard_index_path
    rescue => error
      logger.error "SeniorThesesController::create rescued #{error.class}\n\t#{error.to_s}\n #{error.backtrace.join("\n")}\n\n"
      retval = render :json => [{:error => "Error occurred while creating Senior Thesis."}].to_json
    end
  end

  def show
  end

  def edit

  end

  def update
    CurationConcern::Actions.update_metadata(@senior_thesis, current_user, params)
    flash[:notice] = 'Your files are being processed by ' + t('sufia.product_name') + ' in the background. The metadata and access controls you specified are being applied. Files will be marked <span class="label label-important" title="Private">Private</span> until this process is complete (shouldn\'t take too long, hang in there!). You may need to refresh your dashboard to see these updates.'
    redirect_to sufia.dashboard_index_path
  end

  def destroy
  end

end
