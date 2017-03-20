Tmanager::Application.routes.draw do

  scope '/api' do
    scope '/v1' do
      scope '/email' do
        post '/exists' => 'users#email_exists'
      end
      scope '/username' do
        post '/exists' => 'users#username_exists'
      end
      scope '/tournaments' do
        post '/addGame2Tournament' => 'tournaments#addGame2Tournament'
        post '/deleteGame2Tournament' => 'tournaments#deleteGame2Tournament'
        post '/generate_matches' => 'tournaments#api_generate_matches'
      end
      scope '/matches/:id' do
        post '/setScore' => 'matches#set_scores'
      end
    end
  end

  resources :matches

  devise_for :users, :controllers => { registrations: 'registrations', :omniauth_callbacks => 'omniauth_callbacks' }
  match '/users/:id/finish_signup' => 'users#finish_signup', via: [ :get, :put], :as => :finish_signup

  resources :users do
    get "make_admin" => "users#make_admin"
    get "unmake_admin" => "users#unmake_admin"
    get "calculate_points" => "users#calculate_points"
  end
  get "ranking" => "users#ranking"

  root :to => 'pages#home'
  resources :games
  resources :games_images
  resources :tournaments do
    post "matches/all" => "matches#update_many"
    get "set_scores" => "tournaments#set_scores"
    get "generate_matches" => "tournaments#generate_matches"
    resources :games do
      post "add" => "games#add_to_tournament"
      post "delete" => "games#del_from_tournament"
      get "subscribe" => "users#subscribe"
      get "unsubscribe" => "users#unsubscribe"
    end
  end


  #Must be the last
  if !Rails.env.development?
    match "*a", :to => "application#routing_error"
  end

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
  # match ':controller(/:action(/:id))(.:format)'
end
