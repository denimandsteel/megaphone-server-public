class AddInAppFlagToVendors < ActiveRecord::Migration
  def up
    add_column :vendors, :in_app, :boolean
    rename_column :products, :on_sale, :in_app
  end

  def down
    add_column :vendors, :in_app, :boolean
    rename_column :products, :in_app, :on_sale
  end  
end
