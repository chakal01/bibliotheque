Rails.application.routes.draw do
  get 'parametres', to: "parametres#index"
  post 'parametres', to: "parametres#save"

  devise_for :users #, controllers: { sessions: "users/sessions" }
  get 'scans', to: "scans#index"

  resources :livres do
    member do
      get :avatar
      post :avatar, to: :save_avatar
    end
      get ':isbn/get_datas', on: :collection, to: 'livres#get_datas'
  end

  resources :auteurs do
    get :autocomplete_auteur_nom, on: :collection
    get :fusion, on: :collection
    post :fusion, on: :collection, to: :choix_fusion
    post :fusionner, on: :collection
    member do
      get :avatar
      post :avatar, to: :save_avatar
    end
  end

  resources :editions do
    get :autocomplete_edition_nom, on: :collection
    get :fusion, on: :collection
    post :fusion, on: :collection, to: :fusionner
  end


  resources :genres do
    get :autocomplete_genre_nom, on: :collection
    get :fusion, on: :collection
    post :fusion, on: :collection, to: :fusionner
  end

  resources :emplacements do
    get :autocomplete_emplacement_nom, on: :collection
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'livres#index'

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
