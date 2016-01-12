Rails.application.routes.draw do


  root to: 'home#index'
  get 'competition' => 'competitions#index'
  get 'competitions/team/:id' => 'competitions#team'
  get 'competitions/shows' => 'competitions#shows'
  get 'competitions/login_in' => 'competitions#login_in'
  resources :competitions, only: [:index, :show] do
    collection do
      # post :valid_apply
      post :valid_create_team
      post :add_user_apply_info
      get :apply_in
      get :event_teams
      post :reduce_team_amount
      post :delete_team
      post :leader_delete_player
      post :valid_team_code
      post :send_email_code
      post :reset_team_code_by_mobile
      post :reset_team_code_by_email
    end
  end
  resources :creative_activities
  resources :news

  devise_for :users, controllers: {sessions: 'users/sessions', registrations: 'users/registrations'}
  captcha_route

  resources :accounts, only: [:new, :create, :destroy] do
    collection do
      get :register
      post :register_post
      post :validate_captcha
      get :forget_password
      get :reset_password
      post :reset_password_post
      post :send_code
      post :register_email_exists
      post :register_mobile_exists
      post :register_nickname_exists
    end
  end


  # -----------------------------------------------------------
  # User
  # -----------------------------------------------------------

  get 'user' => redirect('/user/preview')

  match 'user/preview' => 'user#preview', as: 'user_preview', via: [:get, :post]
  match 'user/profile' => 'user#profile', as: 'user_profile', via: [:get, :post]
  match 'user/update_avatar' => 'user#update_avatar', as: 'user_update_avatar', via: [:post]
  match 'user/remove_avatar' => 'user#remove_avatar', as: 'user_remove_avatar', via: [:post]
  match 'user/passwd' => 'user#passwd', as: 'user_passwd', via: [:get, :post]
  match 'user/mobile' => 'user#mobile', as: 'user_mobile', via: [:get, :post]
  match 'user/add_mobile' => 'user#add_mobile', as: 'user_add_mobile', via: [:get, :post]
  match 'user/notification' => 'user#notification', as: 'user_notification', via: [:get, :post]
  match 'user/comp' => 'user#comp', as: 'user_comp', via: [:get, :post]
  match 'user/creative_activity' => 'user#creative_activity', as: 'user_creative_activity', via: [:get, :post]
  get 'user/activity_show' => 'user#activity_show'
  get 'user/comp_show' => 'user#comp_show'
  post 'user/update_team_cover' => 'user#update_team_cover', as: 'user_update_team_cover'
  get 'discourse/sso' => 'discourse_sso#sso'
  namespace :user do |u|

    resources :likes, only: [:index, :create, :destroy]

  end
  get 'test' => 'test#index'

  # -----------------------------------------------------------
  # Admin
  # -----------------------------------------------------------

  get '/admin/' => 'admin#index'

  namespace :admin do |admin|

    resources :accounts, only: [:new, :index, :create, :destroy] do
      collection do
        get :change_password
        post :change_password_post
      end
    end

    resources :admins
    resources :competitions do
      collection do
        get :get_events
      end
    end
    resources :events do
      collection do
        get :teams
        get :scores
        get :add_score
        post :add_score
        get :edit_score
        post :edit_score
        post :create_team
        post :add_team_player
        post :delete_team_player
        post :delete_team
      end
    end
    resources :users
    resources :organizers
    resources :teams
    resources :creative_activities do
      collection do
        post :add_expert_score
        post :edit_expert_score
        post :audit
      end
    end
    resources :scores do
      collection do
        post :get_teams
      end
    end
    resources :news
    resources :news_types
    resources :schedules
    resources :referees
    resources :roles
    resources :districts
    resources :vouchers

  end
  # This line mounts Refinery's routes at the root of your application.
  # This means, any requests to the root URL of your application will go to Refinery::PagesController#home.
  # If you would like to change where this extension is mounted, simply change the
  # configuration option `mounted_path` to something different in config/initializers/refinery/core.rb
  #
  # We ask that you don't use the :as option here, as Refinery relies on it being the default of "refinery"
  # mount Refinery::Core::Engine, at: Refinery::Core.mounted_path
  # -----------------------------------------------------------
  # -----------------------------------------------------------

  namespace :kindeditor do
    post '/upload' => 'assets#create'
    get '/filemanager' => 'assets#list'
  end


  if Rails.env.development?
    # if Rails.env.production?
    match '*path', via: :all, to: 'pages#error_404'
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
