class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name
      t.text   :description
      t.string :city
      t.string :neighbourhood
      t.string :cross_street
      t.string :hours
      t.references :vendor, index: true

      t.timestamps null: false
    end

    remove_column :vendors, :city, :string
    remove_column :vendors, :location, :string
    remove_column :vendors, :cross_street, :string
    remove_column :vendors, :hours, :string
    remove_column :vendors, :neighbourhood, :string
  end
end
