Spree Product Sort
==================

Simple extention to sort products within a taxon.

It works by creating a new DB table to store the product positions for each taxon, and adding an admin view that lets you drag-and-drop them into place.

A product decorator is added which only will show products with a direct relation to a taxon (not the descendents).

Based on: [https://github.com/jdevine/spree-ordering-in-taxons](https://github.com/jdevine/spree-ordering-in-taxons)

Add gem 

    gem 'spree_product_sort', :git => 'https://github.com/oxpeck/spree_product_sort.git'
    bundle install

Use branch '1-2-stable' for Spree 1-2-stable versions.

Add Migration and assets

    rails g spree_product_sort:install