require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :writers
  get 'questions/show'

  devise_for :students, path_names: {:sign_in => 'login', :sign_out => 'logout', :sign_up => 'signup'}
  devise_for :sellers, controllers: {registrations: "sellers/registrations"},
             :path => 'sellers', :path_names => {:sign_in => 'login', :sign_out => 'logout', :sign_up => 'signup'}
  devise_for :admins, :path_names => {:sign_in => 'login', :sign_out => 'logout'}
  root 'home#index'

  namespace :admin do
    get :dashboard, :dashboard_purchases, :dashboard_orders, :paper_statuses, :question_statuses

    resources :essays, path: "papers" do
      post :refresh_thumbnails, path: "refresh-thumbnails", as: :refresh_thumbnails
    end
    resources :categories, :payouts, :coupons, :admins, :writers, :posts, :pages, :transactions, :students, :redemptions
    resources :referencing_styles, path: "referencing-styles"
    resources :faqs, path: "frequently-asked-questions"
    resources :purchases do
      get :heat_map, on: :collection
    end

    resources :sellers, only: [:show, :edit, :destroy, :update, :index] do
      patch :transfer_ownership
    end

    resources :questions do
      get :import, on: :collection
      get :remove_duplicates, on: :collection
    end
    resources :withdrawals, only: [:index]
    resources :froala_uploads, path: "uploads", only: :create
    resources :orders do
      resources :messages
      resource :invoices
    end
  end

  namespace :marketplace do
    get :dashboard

    resources :essays, path: "papers" do
      get :pricing_guide, on: :collection, path: "pricing-guide"
    end
    resources :transactions, :reviews
    resources :sellers, only: [:show, :update]
    resources :withdrawals, only: [:index, :new, :create]
    resource :password, only: [:edit, :update]
  end

  namespace :student do
    resources :students
    resources :orders do
      post :discount

      resources :messages
      resource :reviews
    end
    resources :attachments do
      get :download
    end
    resources :faqs, only: :index, path: "frequently-asked-questions"
    resource :password, as: :pass, only: [:edit, :update]
    resources :redemptions, only: :create
  end

  resource :invoices do
    collection do
      get :paid
      get :revoked
      post :ipn
    end
  end

  resources :essays, path: "papers" do
    collection do
      get :paid
      get :revoked
      post :ipn
      get :download
    end

    member do
      get :purchase
    end
  end

  resources :emails
  resources :faqs, path: "frequently-asked-questions", only: :index
  resources :pages, only: :show
  resources :questions, only: [:show]
  resources :categories, only: [:index, :show]
  resources :posts, only: [:show, :index], path: "blog" do
    resources :comments, only: [:create]
  end

  resources :orders, only: [:new, :create, :update] do
    collection do
      get :personal_info, path: "personal-info"
      get :inquiry
    end
  end

  scope '/admin' do
    authenticate :admin do
      mount Sidekiq::Web, at: '/sidekiq'
    end
  end

  get "student/dashboard" => "student/students#dashboard", as: :student_dashboard
  get "student/how-it-works" => "student/students#how_it_works", as: :student_how_it_works
  get "student/profile" => "student/students#show", as: :student_profile
  get "about" => "home#about", as: :about
  get "contact" => "emails#new", as: :contact
  get "papers/category/:category" => "essays#category", as: :category_essays

  # custom urls
  get ":category/:id" => "posts#category_show", as: :category_post
  get ":category" => "posts#category_index", as: :category_index

  # error pages
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all
  match "/422", :to => "errors#unprocessable_entity", :via => :all

end
