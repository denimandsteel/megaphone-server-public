class AddPaymentMethodToPurchases < ActiveRecord::Migration
  def up
    add_column :purchases, :payment_method, :string
  end

  def down
    remove_column :purchases, :payment_method
  end
end
