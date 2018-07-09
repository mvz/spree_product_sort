# This migration comes from spree_product_sort (originally 20110526085410)
# This migration comes from spree_product_sort (originally 20110526085410)
class CreateProductTaxons < ActiveRecord::Migration
  def up
    create_table :spree_product_taxons do |t|
      t.timestamps
      t.integer 'product_id'
      t.integer 'taxon_id'
      t.integer 'position', default: 1
    end

    # turn products_taxons into product_taxons with an initial order...
    Spree::ProductTaxon.skip_callback("create", :after, :update_positions)
    last = 0
    i = 0

    sq = "
      select product_id,
      taxon_id,
      parent_id
      from spree_products_taxons
      inner join spree_taxons
      on spree_taxons.id = spree_products_taxons.taxon_id
      order by taxon_id, product_id, parent_id
    "
    
    ActiveRecord::Base.connection.execute(sq).each_with_index do |res, index|
        spid = res[0]
        pid = spid.to_i
        tid = res[1].to_i
        parent_id = res[2].to_i

        if last != tid
          i = 0
          last = tid
        end

        pt = Spree::ProductTaxon.new(product_id: pid, taxon_id: tid)
        pt.position = i
        pt.save(validate: false)
        i += 1

        if !parent_id.nil? and parent_id != 0
          Spree::ProductTaxon.where(product_id: pid, taxon_id: parent_id).first_or_create
        end
      end
    Spree::ProductTaxon.set_callback("create", :after, :update_positions)
  end

  def down
    drop_table :spree_product_taxons
  end
end
