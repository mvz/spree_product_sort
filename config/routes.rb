Spree::Core::Engine.append_routes do

  namespace :admin do
		# callback for jQuery sort action
    put 'taxons/reorder_products/:id' => 'taxons#reorder_products'
    get 'product_taxons/positions' => 'product_taxons#positions', :as => :product_sort
    resources :product_taxons do
      collection do
        get :positions
      end
    end

  end
end
