class CreatePurchaseProducts < ActiveRecord::Migration
  def change
    create_table :purchase_products do |t|
      t.references :product, index: true
      t.references :purchase, index: true
      t.integer    :quantity
      
      t.timestamps null: false
    end
  end
end
