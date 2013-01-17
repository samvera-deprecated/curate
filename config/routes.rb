CurateNd::Application.routes.draw do
  Blacklight.add_routes(self)

  devise_for :users

  root to: 'welcome#index'
end
