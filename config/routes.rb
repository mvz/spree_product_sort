# frozen_string_literal: true

Spree::Core::Engine.append_routes do
  namespace :admin do
    get 'product_taxons/positions' => 'product_taxons#positions', as: :product_sort

    resources :product_taxons do
      collection do
        post :update_positions
        get :positions
      end
    end
  end
end
