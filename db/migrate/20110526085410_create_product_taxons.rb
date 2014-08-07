# This migration comes from spree_product_sort (originally 20110526085410)
class CreateProductTaxons < ActiveRecord::Migration
  def up
    create_table :spree_product_taxons do |t|
      t.timestamps
      t.integer 'product_id'
      t.integer 'taxon_id'
      t.integer 'position', :default=>1
    end
    
    # turn products_taxons into product_taxons with an initial order... 
    Spree::ProductTaxon.skip_callback("create", :after, :update_positions)
    last = 0
    i = 0
    ActiveRecord::Base.connection.execute("select product_id, taxon_id, parent_id from spree_products_taxons inner join spree_taxons on spree_taxons.id = spree_products_taxons.taxon_id order by taxon_id, product_id, parent_id").
      each_with_index do |res, index|
        pid = res["product_id"].to_i
        tid = res["taxon_id"].to_i
        parent_id = res["parent_id"].to_i

        if last != tid
          i = 0
          last = tid
        end

        pt = Spree::ProductTaxon.new(:product_id=>pid, :taxon_id=>tid)
        pt.position = i
        pt.save(:validate => false)
        i += 1

        if !parent_id.nil? and parent_id != 0
          Spree::ProductTaxon.where(:product_id=>pid, :taxon_id=>parent_id).first_or_create
        end
      end
    Spree::ProductTaxon.set_callback("create", :after, :update_positions)
    # create an extra PTs  for each product with taxon=0 for Homepage
    # ActiveRecord::Base.connection.
    #   execute("select id from spree_products order by id").
    #   each_with_index do |res, index|
    #     pid = res[0].to_i
        
    #     pt = Spree::ProductTaxon.new(:product_id=>pid, :taxon_id=>0)
    #     pt.position = index
    #     pt.save(:validate => false)
    #   end
  end

  def down
    puts "HERE"
    drop_table :spree_product_taxons
  end
end
