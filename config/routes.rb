Rails.application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :disasters
  end

  resources :posts do
    resources :comments
  end

  root 'posts#index'

end
