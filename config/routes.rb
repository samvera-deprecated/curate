Rails.application.routes.draw do
  namespace :curation_concern, path: :concern do
    resources(
      :generic_files,
      only: [:new, :create],
      path: 'container/:parent_id/generic_files'
    )
    resources(
      :generic_files,
      only: [:show, :edit, :update, :destroy]
    )
  end
end
