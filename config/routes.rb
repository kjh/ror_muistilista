ActionController::Routing::Routes.draw do |map|
  map.resource :session
  map.resources :tasks
end
