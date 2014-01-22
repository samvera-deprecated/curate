class Curate::OrganizationsController < ApplicationController
  include Blacklight::Catalog
  include Sufia::Noid

  prepend_before_filter :normalize_identifier, only: [:show]

  with_themed_layout '1_column'

  add_breadcrumb 'Organizations', lambda {|controller| controller.request.path }

  before_filter :authenticate_user!, except: :show
  before_filter :agreed_to_terms_of_service!
  before_filter :force_update_user_profile!

  def new
    @organization = Organization.new
  end

  def  create
    puts "~~~~~~~~~~~~~~"
    puts params.inspect
    puts "~~~~~~~~~~~~~~"
    @organization.title =
    @organization.apply_depositor_metadata(current_user.user_key)
    @organization.save
    puts "@@@@@@@@@"
    puts @organization.pid
    redirect_to 'show'
  end
end
