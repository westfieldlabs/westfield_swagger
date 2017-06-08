Rails.application.routes.draw do
  mount WestfieldSwagger::Engine => "/westfield_swagger"

  resources :test, only: :index
end
