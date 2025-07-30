Rails.application.routes.draw do
  get "stage_responses/create"
  devise_for :users

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  get '/dashboard', to: 'users#dashboard', as: :dashboard




  get "up" => "rails/health#show", as: :rails_health_check

  resources :complaints, only: [ :new, :index, :show, :create, :destroy ] do
    resources :user_complaints, only: [ :create]
  end

  resources :users, only: [ :new, :index, :show, :create, :destroy ] do
    resources :user_complaints, only: [ :create]
  end

  patch 'approve_stage/:id', to: 'stage_responses#approve', as: :approve_stage

  get 'user/:id/complaints', to: 'user_complaints#user_complaints_by_role', as: :user_complaints_by_role

  get 'messages', to: 'complain_messages#index'
  get 'messages/:id', to: 'complain_messages#show'
  delete 'messages/:id', to: 'complain_messages#destroy'
  post 'messages', to: 'complain_messages#create'


  #get each user his/her count
  get 'user/complaintcounts/:id', to: 'users#user_complaints_count'

  get '/admin', to: 'users#admin_dashboard', as: :admin_dashboard


  resources :stage_responses, only: [:create]


  patch '/resolve-complaint/:id', to: 'complaints#resolve', as: 'resolve_complaint'
  #resolve route for only forwarded complaints

  root to: 'users#dashboard'


end
