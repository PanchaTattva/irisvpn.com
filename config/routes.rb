Rails.application.routes.draw do
  devise_for :admins, :controllers => {:registrations => 'admins/registrations'}
  devise_scope :admin do
    get '/admin' => "admins#index", :as => :admin_root
    get 'admins', to: 'admins#index'
    get 'admins/show', to: 'admins#show'
    get 'admins/user_activate', to: 'admins#user_activate'
  end

  devise_for :users
  devise_scope :user do
    get '/user' => "users#index", :as => :user_root
    get 'users', to: 'users#index'
  end

  get 'welcome/index'
  root 'welcome#index'

  get 'pricing', to: 'pricing#index'
  get 'contact', to: 'contact#index'
  get 'faq', to: 'faq#index'
  get '/privacy.txt', :to => redirect('/assets/privacy.txt')

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
