Rails.application.routes.draw do
  devise_for :users



  namespace :admin do
    resources :disasters
  end

  resources :posts do
    resources :comments
  end
  get '/:short_url' => 'posts#redirect'
  root 'posts#index'

end
