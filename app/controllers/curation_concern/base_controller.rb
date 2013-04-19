module CurationConcern
  class BaseController < ApplicationController
    before_filter :attach_action_breadcrumb
    def attach_action_breadcrumb
      case action_name
      when 'show'
        add_breadcrumb curation_concern.human_readable_type, request.path
      when 'new', 'create'
        add_breadcrumb "New #{curation_concern.human_readable_type}", request.path
      else
        add_breadcrumb curation_concern.human_readable_type, polymorphic_path([:curation_concern, curation_concern])
        add_breadcrumb action_name.titleize, request.path
      end
    end
    protected :attach_action_breadcrumb

    layout 'curate_nd'
    include Sufia::Noid # for normalize_identifier method

    before_filter :authenticate_user!, :except => [:show]
    before_filter :agreed_to_terms_of_service!
    prepend_before_filter :normalize_identifier, except: [:index, :new, :create]
    before_filter :curation_concern, except: [:index]
    load_and_authorize_resource :curation_concern, except: [:index, :new, :create], class: "ActiveFedora::Base"

    attr_reader :curation_concern
    helper_method :curation_concern

    def contributor_agreement
      @contributor_agreement ||= ContributorAgreement.new(curation_concern, current_user, params)
    end
    helper_method :contributor_agreement

    def save_and_add_related_files_submit_value(override_name = action_name)
      verb_name = ['create', 'new'].include?(override_name) ? 'Create' : 'Update'
      "#{verb_name} and Add Related Files..."
    end
    helper_method :save_and_add_related_files_submit_value

  end
end
