Broker::Application.routes.draw do
require 'sidekiq/web'
authenticate :user, lambda { |u| u.admin? } do
  mount Sidekiq::Web => '/sidekiq'
end

#  resources :machines

  resources :cloud_servers do
    resources :images
  end

  # Administracion
  get "administration/list_users"
  get "administration/list_groups"
  get "administration/users_from_group"
  put "administration/toggle_approved_user"
  get 'administration/edit_user/:id', to: 'administration#edit_user', as: 'administration_edit_user'
  put 'administration/update_user/:id', to: 'administration#update_user', as: 'administration_update_user'
  delete "administration/delete_user"
  get 'administration/upload_csv'
  post 'administration/check_file'
  get 'administration/create_users'

  post 'machines/create/:id', to: 'machines#create', as: 'create_machine'
  get 'machines/:id', to: 'machines#show', as: 'machine'
  get 'machines', to: 'machines#index', as: 'machines'
  delete 'machines/:id', to: 'machines#destroy', as: 'destroy_machine'
  get 'machines/reboot/:id', to: 'machines#reboot', as: 'reboot_machine'

  resources :roles

  devise_for :users
  get "welcome/index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

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
