Spree Product Sort
==================

Simple extention to sort products within a taxon.

It works by creating a new DB table to store the product positions for each taxon, and adding an admin view that lets you drag-and-drop them into place.

A product decorator is added which only will show products with a direct relation to a taxon (not the descendents).

Based on: [https://github.com/jdevine/spree-ordering-in-taxons](https://github.com/jdevine/spree-ordering-in-taxons)

### Installation

Add the following to your Gemfile

```
  gem 'spree_product_sort',     github: '5-stones/spree_product_sort',          branch: '3-0-stable'
```

Then run `bundle install`

Add Migration and assets

```
  rails g spree_product_sort:install
```

### Known Issues

- it will break spree's sample_data import
