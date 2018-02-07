# frozen_string_literal: true

Spree::Product.class_eval do
  has_many :product_taxons
  has_many :taxons, through: :product_taxons

  scope :ordered, -> { includes(:product_taxons).order('spree_product_taxons.position') }

  after_create :create_product_taxon

  def create_product_taxon
    # new product added, create initial product_taxon assignment so that products on the main page can also be sorted.
    Spree::ProductTaxon.create(product_id: id, taxon_id: 0)
  end

  def in_taxon?(taxon)
    case taxon
    when String
      taxons.map { |t| [t.name.downcase, t.permalink.downcase] }.flatten.include?(taxon.strip.downcase)
    when Integer
      taxons.map(&:id).include?(taxon)
    when Taxon
      taxons.include?(taxon)
    else
      false
    end
  end

  # Can't use add_search_scope for this as it needs a default argument
  def self.available(available_on = nil, currency = nil)
    scope = joins(master: :prices).where("#{Spree::Product.quoted_table_name}.available_on <= ?", available_on || Time.now)
    unless Spree::Config.show_products_without_price
      scope = scope.where('spree_prices.currency' => currency || Spree::Config[:currency]).where('spree_prices.amount IS NOT NULL')
    end
    scope = scope.includes(:product_taxons).order('spree_product_taxons.taxon_id, spree_product_taxons.position')
  end
  search_scopes << :available

  add_search_scope :in_taxon do |taxon|
    select('DISTINCT(spree_products.id), spree_products.*, spree_product_taxons.taxon_id, spree_product_taxons.position')
      .joins(:taxons)
      .where(Spree::Taxon.table_name => { id: taxon.self_and_descendants.pluck(:id) })
  end
end
