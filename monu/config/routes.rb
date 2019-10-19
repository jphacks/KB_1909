Rails.application.routes.draw do

  namespace 'v1' do
    resources :users
    get '/me', to: 'users#me'
    post 'login', to: 'users#log_in'
    resources :posts
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
