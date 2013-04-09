Dummy::Application.routes.draw do
  namespace :curation_concern, path: :concern do
    resources :mock_curation_concern, except: :index
  end
end
