CaseTracker::Application.routes.draw do
  resources :cases, only: :index
end
