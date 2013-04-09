CurateNd::Application.routes.draw do

  namespace :curation_concern, path: :concern do
    resources :senior_theses, except: :index
  end

end
