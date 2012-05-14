UserLayer::Application.routes.draw do
  get "sensors/index"

  resources :feeds, :mobile_users

  resources :cares do 
    resources :apps
  end
  
  namespace :api do
    resources :feeds
    resources :sensors do
      resources :files
      member do
        get :data
      end
      collection do
        get :test_data
      end
    end
  end
  
  resources :sensors do
      collection do
          get "sensocol_demo"
          get "test_data"
    end
  end
  namespace :sensor do
    resources :weathers do
      collection do
        post "geocode"
      end
    end
    resources :randoms
  end
    
  devise_for :users
  as :user do
    get 'signin' => 'rsi/portals#land', :as => :new_user_session
    delete "/logout" => "rsi/sessions#destroy"
  end 
  
  root :to=>"rsi/charts#index"
  
  namespace :rsi do
    namespace :admin do
      resources :users do
        member do
          post :inspect
        end
        collection do
          post :uninspect
        end
      end
    end
    
    resources :sessions, :relations
    
    resources :accounts do
      collection do
        get :check
        post :pwd
      end
    end
    
    resources :settings do
      collection do
        post :alert, :locale, :hide
      end
    end
    
    resources :portals do
      collection do 
        get :land
      end
    end
    
    resources :activities do
      member do
        get :invite
        post :join
      end
    end
    resources :charts do
      collection do
        get :data, :average, :percent
      end
      member do
        post :active
      end
    end
    
    resources :friends do
      collection do
        get :invite
        post :weibo
      end
      member do
        post :join
      end
    end
    
    get "screen_saver" => "screen_saver#index"
  end
  
  match 'auth/:provider/callback' => 'rsi/accounts#create'
  match 'act/:token' => 'rsi/activities#invite'
  match 'f/:token' => 'rsi/friends#follow'
  match 'db/query' => 'rsi/charts#data'
  match 'home' => 'rsi/portals#land'
  match 'info' => 'rsi/portals#info'
  match 'about' => 'rsi/portals#about'
  match 'policy' => 'rsi/portals#policy'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
