# frozen_string_literal: true

Spree::Taxon.class_eval do
  has_many :product_taxons, -> { order('spree_product_taxons.position') }
  has_many :products, -> { order('spree_product_taxons.position') }, through: :product_taxons

  def taxon_hierarchy_display
    if parent
      "#{parent.name} -> #{name}"
    else
      name.to_s
    end
  end
end
