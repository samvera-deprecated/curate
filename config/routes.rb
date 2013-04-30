CurateNd::Application.routes.draw do
  devise_for :users do
    get 'dashboard', to: 'dashboard#index', as: :user_root
  end

  namespace :curation_concern, path: :concern do
    resources :senior_theses, except: :index
  end

end
