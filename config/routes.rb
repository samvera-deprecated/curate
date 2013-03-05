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
  resources :downloads, only: [:show]

  namespace :curation_concern, path: :concern do
    resources :senior_theses, except: :index
    resources(
      :generic_files,
      only: [:new, :create],
      path: 'container/:parent_id/generic_files'
    )
    resources(
      :generic_files,
      only: [:show, :edit, :update]
    )
  end

  resources :terms_of_service_agreements, only: [:new, :create]

  match "classify" => "classify#new", via: :get
  match "classify" => "classify#create", via: :post
  root to: 'welcome#index'
end
