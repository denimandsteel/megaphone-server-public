class AddEditedByAndAddedByColumnsToVendorsAndAdministrators < ActiveRecord::Migration
  def up
    add_column :administrators, :created_by, :string
    add_column :vendors, :updated_by, :string
  end
  def down
    remove_column :administrators, :created_by, :string
    remove_column :vendors, :updated_by, :string    
  end
end
