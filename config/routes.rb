CurateNd::Application.routes.draw do
  Blacklight.add_routes(self)
  HydraHead.add_routes(self)
  Hydra::BatchEdit.add_routes(self)


  devise_for :users
  mount Sufia::Engine => '/'


  root to: 'welcome#index'
end
