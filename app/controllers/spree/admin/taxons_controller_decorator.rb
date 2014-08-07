Spree::Admin::TaxonsController.class_eval do

  def reorder_products
    params[:product_taxons].each_with_index do |ptid, idx|
      pt = Spree::ProductTaxon.find(ptid.to_i)
      pt.insert_at(idx) unless pt.position == idx
    end
    head :created
  end

end
