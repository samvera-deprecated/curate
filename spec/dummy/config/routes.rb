Dummy::Application.routes.draw do
  # devise_for :users, :controllers => { :registrations => :registrations }

  namespace :curation_concern, path: :concern do
    resources :mock_curation_concerns, except: :index
  end
end
