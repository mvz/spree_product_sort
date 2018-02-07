# frozen_string_literal: true

module Spree
  module Admin
    class ProductTaxonsController < ResourceController
      def positions
        if params[:custom_taxon_id].present?
          @taxon = Spree::Taxon.joins(:product_taxons).find(params[:custom_taxon_id])
        end
        # List of taxons, beginnning with a virtual taxons for Home, and then all taxons with pts
        @taxons = []
        @taxons |= Spree::Taxon.order(:name)
      end
    end
  end
end
