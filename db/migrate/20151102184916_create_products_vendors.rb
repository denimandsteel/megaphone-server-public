class CreateProductsVendors < ActiveRecord::Migration
  def change
    create_table :products_vendors do |t|
      t.references :product, index: true
      t.references :vendor, index: true
    end
  end
end
