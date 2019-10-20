Rails.application.routes.draw do

  namespace 'v1' do
    resources :users
    get '/me', to: 'users#me'
    post 'login', to: 'users#log_in'

    resources :posts

    post 'images/:post_id', to: 'images#create'
    get 'images/:post_id', to: 'images#show'

    post 'posts/:id/good', to: 'posts#good'
  end

  namespace 'v2' do
    resources :users
    get '/me', to: 'users#me'
    post 'login', to: 'users#log_in'

    resources :posts

    post 'images/:post_id', to: 'images#create'
    get 'images/:post_id', to: 'images#show'

    post 'posts/:id/good', to: 'posts#good'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
