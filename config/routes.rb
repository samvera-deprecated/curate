CurateNd::Application.routes.draw do
  Blacklight.add_routes(self)
  HydraHead.add_routes(self)
  Hydra::BatchEdit.add_routes(self)

  devise_for :users

  resources 'dashboard', :only=>:index do
    collection do
      get 'page/:page', :action => :index
      get 'facet/:id',  :action => :facet, :as => :dashboard_facet
      get 'related/:id',:action => :get_related_file, :as => :related_file
    end
  end

  namespace :curation_concern, path: :concern do
    resources :senior_theses, except: :index
    resources :generic_files, only: [:show, :edit]

    # The following routes are tested
    match(
      ':parent_curation_concern_id/related_files' => 'related_files#index',
      via: :get
    )
    match(
      ':parent_curation_concern_id/related_files' => 'related_files#create',
      via: :post
    )
    match(
      ':parent_curation_concern_id/related_files/new' => 'related_files#new',
      via: :get
    )
    match(
      ':parent_curation_concern_id/related_files/:id' => 'related_files#show',
      via: :get
    )
    match(
      ':parent_curation_concern_id/related_files/:id' => 'related_files#destroy',
      via: :delete
    )
    match(
      ':parent_curation_concern_id/related_files/:id' => 'related_files#update',
      via: :put
    )
    match(
      ':parent_curation_concern_id/related_files/:id/edit' => 'related_files#edit',
      via: :get
    )
  end

  resources :terms_of_service_agreements, only: [:new, :create]

  match "classify" => "classify#index"
  root to: 'welcome#index'
end
