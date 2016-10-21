Rails.application.routes.draw do
  get 'welcome/signup'
  post 'welcome/signup'
  get 'welcome/login'
  post 'welcome/login'
  get 'welcome/index'
  post 'welcome/index'
  get 'welcome/index'
  root 'welcome#index'

  resources :posts
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
