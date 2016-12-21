class AddTipsToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :tips, :integer
  end
end
