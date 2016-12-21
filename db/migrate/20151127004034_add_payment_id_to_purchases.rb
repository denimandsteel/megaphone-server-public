class AddPaymentIdToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :payment_id, :string
  end
end
