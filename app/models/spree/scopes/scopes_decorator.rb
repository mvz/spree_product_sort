Spree::Product.class_eval do
  self.add_search_scope :in_taxon do |taxon|
    taxon_self_and_descendants_ids = taxon.self_and_descendants.pluck(:id)
    select("spree_products.id, spree_products.*").
    where(id: Spree::ProductTaxon.select('spree_product_taxons.product_id').
          joins(:taxon).
          where(Spree::Taxon.table_name => { :id => taxon_self_and_descendants_ids })
         ).
    where(spree_product_taxons: { taxon_id: taxon_self_and_descendants_ids })
  end
end