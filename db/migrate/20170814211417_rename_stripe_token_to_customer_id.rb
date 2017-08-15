class RenameStripeTokenToCustomerId < ActiveRecord::Migration
  def up
    rename_column :devices, :payment_token, :stripe_customer
  end

  def down
    rename_column :devices, :stripe_customer, :payment_token
  end
end
