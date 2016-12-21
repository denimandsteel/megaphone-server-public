class AddTransactionIdAndChangeAmountOnPurchases < ActiveRecord::Migration
  def up
    rename_column :purchases, :amount, :products_amount
    add_column :purchases, :transaction_id, :string
  end
  def down
    rename_column :purchases, :products_amount, :amount
    remove_column :purchases, :transaction_id, :string
  end
end
