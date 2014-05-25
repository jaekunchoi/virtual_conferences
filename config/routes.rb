VirtualExhibition::Application.routes.draw do

  mount Resque::Server, :at => "/resque"

  # Venues
  get "venues/dashboard", :to => "venues#dashboard"
  get "venues/general_settings", :to => "venues#general_settings"
  get "venues/networking_and_communication", :to => "venues#networking_and_communication"
  get "venues/announcement_board", :to => "venues#announcement_board"
  get "venues/promotional_board", :to => "venues#promotional_board"
  get "venues/privacy_statement", :to => "venues#privacy_statement"

  # Events
  get "display_event/:id" => "events#display_event", as: :display_event
  get "events/all_events", :to => "events#all_events", as: :all_events
  get "events/all_events_public", :to => "events#all_events_public", as: :all_events_public
  get "events/:id/event_registration_page", :to => "events#event_registration_page", as: :event_registration_page
  get "events/:id/visit" => "events#visit", as: :event_visit

  # Booths
  get "booths/:id/about" => "booths#about", as: :booth_about
  get "booths/:id/about_ie" => "booths#about_ie", as: :booth_about_ie
  get "booths/:id/leave_business_card" => "booths#leave_business_card", as: :booth_leave_business_card
  get "booths/:id/products" => "booths#products", as: :booth_products
  get "booths/:id/products_ie" => "booths#products_ie", as: :booth_products_ie
  get "booths/:id/literature" => "booths#literature", as: :booth_literature
  get "booths/:id/literature_ie" => "booths#literature_ie", as: :booth_literature_ie
  get "booths/:id/contact_info" => "booths#contact_info", as: :booth_contact_info
  get "booths/:id/contact_info_ie" => "booths#contact_info_ie", as: :booth_contact_info_ie
  get "booths/:id/partners" => "booths#partners", as: :booth_partners
  get "booths/:id/partners_ie" => "booths#partners_ie", as: :booth_partners_ie
  get "booths/:id/presentations" => "booths#presentations", as: :booth_presentations
  get "booths/:id/presentations_ie" => "booths#presentations_ie", as: :booth_presentations_ie
  get "booths/:id/videos" => "booths#videos", as: :booth_videos
  get "booths/:id/videos_ie" => "booths#videos_ie", as: :booth_videos_ie
  get "booths/:id/chat_widget" => "booths#chat_widget", as: :booth_chat
  post "booths/:id/send_message" => "booths#send_message", as: :booth_send_message
  post "booths/:id/send_business_card" => "booths#send_business_card", as: :booth_send_business_card
  get "booths/:id/booth_rep" => "booths#booth_rep", as: :booth_rep

  get "oauth2callback" => "google_apis#oauth2callback", as: :oauth2callback

  get "privacy", :to => "visitors#privacy", as: :privacy
  get "invite_users", :to => "users#invite_users", as: :invite_users
  put "read_all_booth_user_chats", :to => "chats#read_all_booth_user_chats", as: :read_all_booth_user_chats
  get "parse_csv", :to => "visitors#parse_csv"
  match "users/export_users_to_csv_by_event", :to => "users#export_users_to_csv_by_event", via: [:get, :post]
  get "export_attendees", :to => "users#export_attendees"
  match 'update_users' => 'users#update_users', via: :get
  match 'update_user_events' => 'users#update_user_events', via: :get

  post 'users/create_user' => 'users#create_user', as: :create_user
  get 'users/import/new' => 'users#import_new', as: :import_users
  post 'users/import/process' => 'users#import_process', as: :import_users_process
  get 'users/import/complete' => 'users#import_complete', as: :import_users_complete
  

  #Videos
  resources :contents do
    collection do
      get :getdata
    end
    member do
      get :preview
      get :view
    end
  end


  

  resources :venues, shallow: true do
    get "hall/:id/exhibition" => "halls#exhibition", as: :exhibition
    get "hall/:id/visit" => "halls#visit", as: :hall_visit
    get "structure", :to => "venues#venue_structure"
    resources :asset_types, :booths_tags, :tags, :uploaded_files, :events, :contents
    resources :halls do
      resources :webcasts do
        resources :chats, :moderated_chats
      end
      resources :booths do
        resources :chats
      end
    end
    resources :booths do
      resources :chats
    end
  end

  authenticated :user do
    root :to => 'venues#dashboard', as: :devise_root
  end

  root :to => redirect("/users/sign_in")

  devise_for :admins
  devise_for :users, :controllers => {:registrations => "registrations", sessions: "sessions", :omniauth_callbacks => "omniauth_callbacks"}

  resources :products, :templates, 
  :asset_types, :chats, :moderated_chats, :users, :tags

  devise_scope :user do
    get "login", :to => "devise/sessions#new"
    get "users/sign_up/:id", :to => "registrations#new"
  end

  namespace :api do
    namespace :v1 do
      resources :users, :roles, :venues
    end
  end
end
