class CreateVendors < ActiveRecord::Migration
  def change
    create_table :vendors do |t|
      t.string :name
      t.string :city
      t.string :location
      t.string :cross_street
      t.string :hours
      t.text   :description
      t.string :neighbourhood
      t.string :image
      
      t.timestamps null: false
    end
  end
end
