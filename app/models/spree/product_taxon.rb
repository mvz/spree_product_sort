class Spree::ProductTaxon < ActiveRecord::Base
  belongs_to :product
  belongs_to :taxon
  default_scope { order('spree_product_taxons.position') }
  acts_as_list scope: :taxon
end
