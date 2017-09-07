class AddPaymentMethodToDevices < ActiveRecord::Migration
  def up
    add_column :devices, :preferred_payment_method, :string
  end

  def down
    remove_column :devices, :preferred_payment_method
  end
end
