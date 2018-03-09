# -*- encoding : utf-8 -*-
PersonalSite::Application.routes.draw do

  get '/interface/blogs/all', :to => 'interface::blogs#all', :as => 'interface_blogs_all'
  get '/interface/blogs/show', :to => 'interface::blogs#show', :as => 'interface_blogs_show'
  post '/interface/blogs/add_comment', :to => 'interface::blogs#add_comment', :as => 'interface_blogs_add_comment'

  # 这个东西不能省略, 否则会报错
  mount Refinery::Core::Engine, :at => '/'
  root :to => 'pages#home', :via => :get
  post 'pages/preview'     => 'pages#preview', :as => :preview_pages
  match 'pages/*path/preview' => 'pages#preview', :as => :preview_page,  :via => [:get, :put]
  get '/pages/:id', :to => 'pages#show', :as => :page


  namespace :admin, :path => 'refinery' do
    get 'pages/*path/edit', :to => 'pages#edit'
    get 'pages/*path/children', :to => 'pages#children', :as => 'children_pages'
    put 'pages/*path', :to => 'pages#update'
    delete 'pages/*path', :to => 'pages#destroy'
    resources :pages, :except => :show do
      post :update_positions, :on => :collection
    end

    resources :pages_dialogs, :only => [] do
      collection do
        get :link_to
        get :test_url
        get :test_email
      end
    end

    resources :page_parts, :only => [:new, :create, :destroy]
  end

  namespace :blog do
    root :to => "posts#index"
    resources :posts, :only => [:show]

    match 'feed.rss', :to => 'posts#index', :as => 'rss_feed', :defaults => {:format => "rss"}
    match 'categories/:id', :to => 'categories#show', :as => 'category'
    match ':id/comments', :to => 'posts#comment', :as => 'comments'
    get 'archive/:year(/:month)', :to => 'posts#archive', :as => 'archive_posts'
    get 'tagged/:tag_id(/:tag_name)' => 'posts#tagged', :as => 'tagged_posts'
  end

  namespace :blog, :path => '' do
    namespace :admin, :path => 'refinery' do
      scope :path => 'blog' do
        root :to => "posts#index"

        resources :posts do
          collection do
            get :uncategorized
            get :tags
          end
        end

        resources :categories

        resources :comments do
          collection do
            get :approved
            get :rejected
          end
          member do
            get :approved
            get :rejected
          end
        end

        resources :settings do
          collection do
            get :notification_recipients
            post :notification_recipients

            get :moderation
            get :comments
            get :teasers
          end
        end
      end
    end
  end
end
