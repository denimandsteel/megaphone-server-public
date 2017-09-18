class AddApplePaySupport < ActiveRecord::Migration
  def up
    rename_column :devices, :payment_token, :stripe_customer
    add_column :devices, :card_token, :string
    add_column :devices, :apple_pay_token, :string
    add_column :devices, :preferred_payment_method, :string
    add_column :purchases, :payment_method, :string
  end

  def down
    rename_column :devices, :stripe_customer, :payment_token
    remove_column :devices, :card_token
    remove_column :devices, :apple_pay_token
    remove_column :devices, :preferred_payment_method
    remove_column :purchases, :payment_method
  end
end
