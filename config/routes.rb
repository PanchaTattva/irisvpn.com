Rails.application.routes.draw do
  devise_for :users
  get 'pricing', to: 'pricing#index'
  get 'contact', to: 'contact#index'
  get 'faq', to: 'faq#index'
  get 'welcome/index'
  get 'users', to: 'users#index'
  get '/user' => "users#index", :as => :user_root

  get '/privacy.txt', :to => redirect('/assets/privacy.txt')

  root 'welcome#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
