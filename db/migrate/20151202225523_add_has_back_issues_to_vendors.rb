class AddHasBackIssuesToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :has_back_issues, :boolean
  end
end
