LearnApp::Application.routes.draw do

  resources :sessions, only: [:new, :create, :destroy]
  resources :admin
  resources :relationships, only: [:create, :destroy, :index]
  resources :carts, only: [:create, :destroy]
  resources :prerequisites, only: :create
  resources :registrations, only: [:create, :destroy]
  resources :courseregistrations, only: [:create, :destroy]
  resources :exams
  resources :questions
  resources :answers
  resources :examresults
  resources :courseratings
  resources :programratings
  resources :categories
  resources :courses do
    member do
      get :programs, :followers, :wants, :wantpros, :notes, :newexam
    end
  end
  resources :users do
    member do
      get :takenprogs, :students, :coursefollows
    end
  end
  resources :programs do
    member do
      get :courses, :wants, :required_courses, :students, :prereq_tree, :destroycourse
    end
    collection do
      get :prerequisites, :removeprerequisites
    end
  end
  resources :notes do
    member {get 'download'}
  end

  root to: "static_pages#home"
  match '/numberusers',   to: "static_pages#latest_number_users"
  match '/addcourses',    to: "programs#addcourses"
  match '/viewfile',      to: "notes#view"
  match '/passcourse',    to: "courses#passcourse"
  match '/moveupcourse',  to: "courses#listorder_up"
  match '/movedowncourse',to: "courses#listorder_down"
  match '/moveupexam',    to: "exams#listorder_up"
  match '/movedownexam',  to: "exams#listorder_down"
  match '/moveupfile',    to: "notes#listorder_up"
  match '/movedownfile',  to: "notes#listorder_down"
  match '/cart',          to: "users#cart"
  match '/programs',      to: "programs#index"
  match '/newprogram',    to: "programs#new"
  match '/newexam',       to: "exams#new"
  match '/courses',       to: "courses#index"
  match '/creations',     to: "users#creations"
  match '/newcourse',     to: "courses#new"
  match '/search',        to: "search#index"
  match '/database',      to: "admin#database"
  match '/addcategory',   to: "admin#addcategory"
  match '/signup',        to: "users#new"
  match '/signin',        to: "sessions#new"
  match '/signout',       to: "sessions#destroy", via: :delete
  match '/about',         to: "static_pages#about"
  match '/help',          to: "static_pages#help"
  
#  constraints(Subdomain) do
#    match '/' => 'forums#show'
#  end

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
