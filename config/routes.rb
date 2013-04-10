CurateNd::Application.routes.draw do
  devise_for :users

  namespace :curation_concern, path: :concern do
    resources :senior_theses, except: :index
  end

end
